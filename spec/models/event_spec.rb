require 'spec_helper'

describe Event do
  it "should initialize created_at to actual time" do
    Event.create(:account_id => 'value for account_id').created_at.should be_within(1).of(DateTime.now)
  end

  it "should set the default level to 1" do
    Event.new.level.should == 1
  end

  describe "with search query" do
    before(:each) do
      @query = {
        :account_id => 'value for account_id',
        :controller => 'value for controller'
      }
      @values = @query.values
    end
    
    it "should delegate to superclass find if query is a string" do
      Event.superclass.should_receive(:find).with("value for id")
      Event.find("value for id")      
    end

    it "should find all if query is empty" do
      Event.should_receive(:all)

      Event.find({})      
    end
    
    it "should call view methods based on query" do
      Event.should_receive(:find_by_account_id_and_controller)
      Event.find(@query)      
    end
    
    it "should call view methods with options" do
      options = {:option => 'value for option'}
      Event.should_receive(:find_by_account_id_and_controller).
        with(hash_including(options))
      Event.find(@query, options)
    end

    it "should calculate startkey and endkey" do
      Event.should_receive(:find_by_account_id_and_controller).
        with(hash_including(:startkey => @values, :endkey => @values + [{}]))
      Event.find(@query)
    end

    it "should swap startkey and endkey if option descending is true" do
      Event.should_receive(:find_by_account_id_and_controller).
        with(hash_including(:endkey => @values, :startkey => @values + [{}], :descending => true))
      Event.find(@query, :descending => true)
    end
  end
end
