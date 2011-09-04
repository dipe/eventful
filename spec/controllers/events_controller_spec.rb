require 'spec_helper'

describe EventsController do

  def valid_attributes
    {:api_token => 'value-for-api-token', :event => {'account_id' => 'value for account_id'}}
  end
  
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
      Account.should_receive(:find_by_api_token).with('value-for-api-token').and_return(Account.create(:application => "value for application"))
    end
    
    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, valid_attributes
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, valid_attributes
        assigns(:event).should be_a(Event)
      end

      it "redirects to the created event" do
        post :create, valid_attributes
        response.should redirect_to([assigns(:event).account, assigns(:event)])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        Event.any_instance.stub(:save).and_return(false)
        post :create, :api_token => 'value-for-api-token', :event => {'unvalid' => 'params'}
        assigns(:event).should be_a_new(Event)
      end

      it "should not respond with success" do
        Event.any_instance.stub(:save).and_return(false)
        post :create, :api_token => 'value-for-api-token', :event => {}
        response.status.should eq 422
      end
    end
  end
end
