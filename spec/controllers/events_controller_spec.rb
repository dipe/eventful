require 'spec_helper'

describe EventsController do
  
  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event).as_null_object).tap do |event|
      event.stub(stubs) unless stubs.empty?
    end
  end

  def mock_account(stubs={})
    (@mock_account ||= mock_model(Account).as_null_object).tap do |account|
      account.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @account = mock_account
    Account.should_receive(:find).with('value-for-account_id').and_return(@account)
  end
  
  describe "GET index" do

    before(:each) do
      @events = [mock_event(:created_at => Time.now)]
    end
    
    it "assigns found events as @events" do
      WillPaginate::Collection.should_receive(:create).and_return(@events)
      
      get :index, :account_id => 'value-for-account_id'
      assigns(:events).should == @events
    end

    it "call events#find" do
      Event.stub(:count) { 'value for count' }
      Event.should_receive(:find).and_return(@events)
      get :index, :account_id => 'value-for-account_id'
    end

    describe "with query" do
    
      it "pass query to events find method" do
        query = {'foo' => 'value for foo', 'bar' => 'value for bar'}
        Event.should_receive(:count).with(query).and_return('value for count')
        Event.should_receive(:find).with(query, kind_of(Hash)).and_return(@events)
        get :index, :account_id => 'value-for-account_id', :query => query
      end

      it "pass special options to events find method" do      
        Event.stub(:count) { 'value for count' }
        Event.should_receive(:find).
          with(kind_of(Hash), {:descending => true, :skip => 'value for offset', :limit => 'value for per_page'}).
          and_return(@events)

        pager = mock(:pager, :per_page => 'value for per_page', :offset => 'value for offset', :replace => nil)
        WillPaginate::Collection.should_receive(:create).
          with('value for page', kind_of(Fixnum), 'value for count').
          and_yield(pager).and_return(@events)

        get :index, :account_id => 'value-for-account_id', :page => 'value for page'
      end
    end
  end
  
  describe "GET show" do
    it "assigns the requested event as @event" do
      Event.stub(:find).with("value-for-event_id") { mock_event }
      get :show, :account_id => 'value-for-account_id', :id => "value-for-event_id"
      assigns(:event).should be(mock_event)
    end
  end

  describe "GET show_additional_data" do
    it "assigns the requested event as @event" do
      Event.stub(:find).with("value-for-event_id") { mock_event }
      get :show, :account_id => 'value-for-account_id', :id => "value-for-event_id"
      assigns(:event).should be(mock_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { mock_event(:save => true) }
        post :create, :account_id => 'value-for-account_id', :event => {'these' => 'params'}
        assigns(:event).should be(mock_event)
      end

      it "should response with the id of the newly created event"
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { mock_event(:save => false) }
        post :create, :account_id => 'value-for-account_id', :event => {'these' => 'params'}
        assigns(:event).should be(mock_event)
      end

      it "should not respond with success" do
        Event.stub(:new) { mock_event(:save => false) }
        post :create, :account_id => 'value-for-account_id', :event => {}
        response.should_not be_success
      end
    end
  end
end
