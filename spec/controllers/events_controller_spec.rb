require 'spec_helper'

describe EventsController do
  
  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event).as_null_object).tap do |event|
      event.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do

    before(:each) do
      @events = [mock_event(:created_at => Time.now)]
    end
    
    it "assigns found events as @events" do
      WillPaginate::Collection.should_receive(:create).and_return(@events)
      
      get :index
      assigns(:events).should == @events
    end

    it "call events search method twice - 1st for size, 2nd for event list" do
      @events.should_receive(:size).and_return('value for size')
      Event.should_receive(:search).twice.and_return(@events)

      get :index
    end

    describe "with query" do
    
      it "pass query to events search method" do
        @events.stub(:size) { 'value for size' }

        Event.should_receive(:search).twice.with({'foo' => 'value for foo', 'bar' => 'value for bar'}, kind_of(Hash)).and_return(@events)

        get :index, :query => {'foo' => 'value for foo', 'bar' => 'value for bar'}
      end

      it "pass this options to events search method" do      
        @events.stub(:size) { 'value for size' }

        Event.should_receive(:search).
          with(any_args).
          and_return(@events)
        Event.should_receive(:search).
          with(kind_of(Hash), {:descending => true, :skip => 'value for offset', :limit => 'value for per_page'}).
          and_return(@events)

        pager = mock(:pager, :per_page => 'value for per_page', :offset => 'value for offset', :replace => nil)
        WillPaginate::Collection.should_receive(:create).
          with('value for page', kind_of(Fixnum), 'value for size').
          and_yield(pager).and_return(@events)

        get :index, :page => 'value for page'
      end
    end
  end
  
  describe "GET show" do
    it "assigns the requested event as @event" do
      Event.stub(:find).with("37") { mock_event }
      get :show, :id => "37"
      assigns(:event).should be(mock_event)
    end
  end

  describe "GET show_additional_data" do
    it "assigns the requested event as @event" do
      Event.stub(:find).with("37") { mock_event }
      get :show, :id => "37"
      assigns(:event).should be(mock_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { mock_event(:save => true) }
        post :create, :event => {'these' => 'params'}
        assigns(:event).should be(mock_event)
      end

      it "should response with the id of the newly created event"
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        Event.stub(:new).with({'these' => 'params'}) { mock_event(:save => false) }
        post :create, :event => {'these' => 'params'}
        assigns(:event).should be(mock_event)
      end

      it "should not respond with success" do
        Event.stub(:new) { mock_event(:save => false) }
        post :create, :event => {}
        response.should_not be_success
      end
    end
  end
end
