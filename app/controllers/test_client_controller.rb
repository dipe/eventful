$:.unshift File.expand_path('../../../contrib', __FILE__)
require 'eventful_event'

class TestClientController < ApplicationController

  def throw
    begin
      raise RuntimeError.new('Bang!')
    rescue Exception => e
      Eventful::Event.put(:request => request, :exception => e, :extra => {'this' => 'value for this data'})
    end
    redirect_to test_path
  end
end
