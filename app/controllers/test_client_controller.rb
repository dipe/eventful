$:.unshift File.expand_path('../../../contrib', __FILE__)
require 'eventful_event'

class TestClientController < ApplicationController

  def throw
    Eventful::Event.put()
    redirect_to test_errors_path
  end  
end
