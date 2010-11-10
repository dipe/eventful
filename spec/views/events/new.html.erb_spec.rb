require 'spec_helper'

describe "events/new.html.erb" do

  def mock_event(stubs={})
    @mock_event ||= mock("Event", stubs).tap do |m|
      m.class.extend ActiveModel::Naming
      m.class.send :include, ActiveModel::Conversion

      def m.errors
        []
      end
      
      def m.persisted?
        false
      end

      def m.class
        Event
      end

      def m.destroy
      end
      
    end
  end

  before(:each) do
    assign(:event,
           mock_event(:title => "MyString",
                      :message => "MyString",
                      :application => "MyString",
                      :environment => "MyString",
                      :version => "MyString",
                      :controller => "MyString",
                      :action => "MyString",
                      :request_url => "MyText",
                      :request_params => "MyText",
                      :request_data_type => "MyString",
                      :request_data => "MyText",
                      :session_id => "MyString",
                      :session_data_type => "MyString",
                      :session_data => "MyText",
                      :additional_data_type => "MyString",
                      :additional_data => "MyText",
                      :backtrace => "MyText",
                      :node => "MyString",
                      :pid => "MyString"
                      ))
  end

  it "renders new event form" do
    render

    assert_select "form", :action => events_path, :method => "post" do
      assert_select "input#event_title", :name => "event[title]"
      assert_select "input#event_message", :name => "event[message]"
      assert_select "input#event_application", :name => "event[application]"
      assert_select "input#event_environment", :name => "event[environment]"
      assert_select "input#event_version", :name => "event[version]"
      assert_select "input#event_controller", :name => "event[controller]"
      assert_select "input#event_action", :name => "event[action]"
      assert_select "textarea#event_request_url", :name => "event[request_url]"
      assert_select "textarea#event_request_params", :name => "event[request_params]"
      assert_select "input#event_request_data_type", :name => "event[request_data_type]"
      assert_select "textarea#event_request_data", :name => "event[request_data]"
      assert_select "input#event_session_id", :name => "event[session_id]"
      assert_select "input#event_session_data_type", :name => "event[session_data_type]"
      assert_select "textarea#event_session_data", :name => "event[session_data]"
      assert_select "input#event_additional_data_type", :name => "event[additional_data_type]"
      assert_select "textarea#event_additional_data", :name => "event[additional_data]"
      assert_select "textarea#event_backtrace", :name => "event[backtrace]"
      assert_select "input#event_node", :name => "event[node]"
      assert_select "input#event_pid", :name => "event[pid]"
    end
  end
end
