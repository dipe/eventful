$:.unshift File.expand_path('../../../contrib', __FILE__)
require 'eventful_event/base'

ApiTestToken = 'test1234'

class TestClientController < ApplicationController

  def throw
    Account.find(ApiTestToken) rescue Account.create(:id => ApiTestToken, :application => 'Eventful-Test')

    request.params[:controller] = random_element_of(TestExample::Controllers)
    request.params[:action] = random_element_of(TestExample::Actions)
    request.session_options[:id] = random_element_of(TestExample::Sessions)
    exception = random_element_of(TestExample::Exceptions)
    level = random_element_of(TestExample::Levels)
    data = random_element_of(TestExample::XmlDatas)
    extra_data = {:key => 'SOAP', :value => data, :type => :xml} if data.present?

    params[:times].to_i.times do
      begin
        raise exception
      rescue Exception => e
        EventfulEvent::Base.fire(:api_token => ApiTestToken,
                                 :level => level,
                                 :exception => e,
                                 :request => request,
                                 :extra => extra_data,
                                 :created_at => Time.now - rand(1000000)
                                 )
      end
    end

    redirect_to test_path
  end

  private

  def random_element_of(array)
    r = rand(array.size)
    array[r]
  end
end

module TestExample
  XmlDatas = [nil, <<EOT]
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

  Exceptions = [RuntimeError.new("test syntax error, unexpected kEND, expecting $end"),
                ArgumentError.new("wrong number of test arguments (0 for 1)"),
                NoMethodError.new("undefined method `test_method' for main:Object"),
                NameError.new("undefined local variable or method `test_name' for main:Object")
               ]

  Controllers = %w(TestSessionController TestUserController TestBillController)

  Actions = %w(test_index test_show test_edit test_create test_delete)

  Sessions = %w(5b86d0aadca24e2c6155f487ca12a752 217643874aaaccccc827382892839cdd cde878273827eedd877878dd1010deff)

  Levels = [0, 1, 2, 3, 4]
end
