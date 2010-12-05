require 'spec_helper'

describe "events/show.html.erb" do

  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event).as_null_object).tap do |event|
      event.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @event = assign(:event,
                    mock_event(:id => 1,
                               :title => "Title",
                               :message => "Message",
                               :application => "Application",
                               :environment => "Environment",
                               :version => "Version",
                               :controller => "Controller",
                               :action => "Action",
                               :request_url => "MyText",
                               :request_params => "MyText",
                               :request_data_type => "Request Data Type",
                               :request_data => "MyText",
                               :session_id => "Session",
                               :session_data_type => "Session Data Type",
                               :session_data => "MyText",
                               :additional_data_type => "Additional Data Type",
                               :additional_data => "MyText",
                               :backtrace => "MyText",
                               :node => "Node",
                               :pid => "Pid",
                               :created_at => "value for created_at"
                               ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Title/)
    rendered.should match(/Message/)
    rendered.should match(/Application/)
    rendered.should match(/Environment/)
    rendered.should match(/Version/)
    rendered.should match(/Controller/)
    rendered.should match(/Action/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Session/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Node/)
    rendered.should match(/Pid/)
  end
end
