require 'spec_helper'

describe EventsController do
  
  def mock_event(stubs={})
    mock_model(Event).as_null_object.tap do |event|
      event.stub(stubs) unless stubs.empty?
    end
  end

  def mock_account(stubs={})
    mock_model(Account).as_null_object.tap do |account|
      account.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET" do

    before(:each) do
      @event = mock_event
      @account = mock_account
      Account.should_receive(:find).with('value-for-account_id').and_return(@account)
    end
    
    describe " index" do

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
        it "pass it to event's finder" do
          query = {'foo' => 'value for foo', 'bar' => 'value for bar', 'account_id' => @account.id}
          Event.should_receive(:count).with(query).and_return('value for count')
          Event.should_receive(:find).with(query, kind_of(Hash)).and_return(@events)
          get :index, :account_id => 'value-for-account_id', :query => query
        end

        it "pass special options to event's finder" do      
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

    describe " show" do
      it "assigns the requested event as @event" do
        Event.stub(:find).with("value-for-event_id") { @event }
        get :show, :account_id => 'value-for-account_id', :id => "value-for-event_id"
        assigns(:event).should be(@event)
      end
    end

    describe " show_additional_data" do
      it "assigns the requested event as @event" do
        Event.stub(:find).with("value-for-event_id") { @event }
        get :show, :account_id => 'value-for-account_id', :id => "value-for-event_id"
        assigns(:event).should be(@event)
      end
    end
  end
  
  describe "POST create" do
    before(:each) do
      @event = mock_event(:save => true)
      Account.should_receive(:find_by_api_token).with('value-for-api-token').and_return('value for account')
    end
    
    describe "with valid params" do
      it "assigns a newly created event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { @event }
        post :create, :api_token => 'value-for-api-token', :event => {'these' => 'params'}
        assigns(:event).should be(@event)
      end

      it "should response with the id of the newly created event"
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { @event }
        post :create, :api_token => 'value-for-api-token', :event => {'these' => 'params'}
        assigns(:event).should be(@event)
      end

      it "should not respond with success" do
        Event.stub(:new) { mock_event(:save => false) }
        post :create, :api_token => 'value-for-api-token', :event => {}
        response.should_not be_success
      end
    end
  end
end
