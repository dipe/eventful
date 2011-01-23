$:.unshift File.expand_path('../../../contrib', __FILE__)
require 'eventful_event'

XML = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <ns2:citiesForPostCode xmlns:ns2="http://hermes.webservice.unitymedia.convergys.com">
      <ns2:in0>
        <ns1:authToken xmlns:ns1="http://xfire.codehaus.org">ALL</ns1:authToken>
        <ns1:postCode xmlns:ns1="http://xfire.codehaus.org">50933</ns1:postCode>
        <ns1:transactionReference xmlns:ns1="http://xfire.codehaus.org">2d65ce716f9ac0c0f997bc04f1621d09</ns1:transactionReference>
      </ns2:in0>
    </ns2:citiesForPostCode>
  </soapenv:Body>
</soapenv:Envelope>
EOT

TestApiToken = '01234567890'

class TestClientController < ApplicationController

  def throw
    Account.find(ApiTestKey) rescue Account.create(:id => ApiTestKey, :application => 'Eventful-Test')

    begin
      raise RuntimeError.new('Bang!')
    rescue Exception => e
      Eventful::Event.put(:api_token => TestApiToken,
                          :request => request,
                          :exception => e,
                          :extra => {:key => 'SOAP', :value => XML, :type => :xml})
    end
    redirect_to test_path
  end
end
