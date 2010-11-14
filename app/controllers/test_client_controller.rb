$:.unshift File.expand_path('../../../contrib', __FILE__)
require 'eventful_event'

class TestClientController < ApplicationController

  def throw
    Eventful::Event.put(:request => request)
    redirect_to test_path
  end  
end
