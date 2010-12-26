require 'spec_helper'

describe Event do
  it "should initialize created_at to actual time" do
    Event.create.created_at.should be_within(1).of(DateTime.now)
  end

  it "should set the default level to 1" do
    Event.new.level.should == 1
  end

  describe "with search query" do
    before(:each) do
      @query = {
        :environment => 'value for environment',
        :application => 'value for application',
        :controller => 'value for controller'
      }
      @values = ['value for environment', 'value for application', 'value for controller']
    end
    
    it "should call view methods based on query" do
      Event.should_receive(:by_environment_and_application_and_controller)
      Event.search(@query)
      
    end
    
    it "should call view methods with options" do
      options = {:option => 'value for option'}
      Event.should_receive(:by_environment_and_application_and_controller).with(hash_including(options))
      Event.search(@query, options)
    end

    it "should calculate startkey and endkey" do
      Event.should_receive(:by_environment_and_application_and_controller).with(:startkey => @values, :endkey => @values + [{}])
      Event.search(@query)
    end

    it "should swap startkey and endkey if option descending is true" do
      Event.should_receive(:by_environment_and_application_and_controller).with(:endkey => @values, :startkey => @values + [{}], :descending => true)
      Event.search(@query, :descending => true)
    end
  end
end
