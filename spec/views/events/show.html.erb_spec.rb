require 'spec_helper'

describe "events/show.html.erb" do

  before(:each) do
    @now = Time.now
    @event = assign(:event,
                    stub_model(Event,
                               :id => 1,
                               :title => "value for title",
                               :message => "value for message",
                               :application => "value for application",
                               :environment => "value for environment",
                               :version => "value for version",
                               :controller => "value for controller",
                               :action => "value for action",
                               :request_url => "value for request_url",
                               :request_params => "value for request_params",
                               :request_data_type => "value for request_data_type",
                               :request_data => "value for request_data",
                               :session_id => "value for session_id",
                               :session_data_type => "value for session_data_type",
                               :session_data => "value for session_data",
                               :additional_data_type => "value for additional_data_type",
                               :additional_data => "value for additional_data",
                               :backtrace => "value for backtrace",
                               :node => "value for node",
                               :pid => "value for pid",
                               :created_at => @now,
                               :to_param => 'value for to_param'
                               ))
  end

  it "renders attribute values" do
    render
    rendered.should match(/value for title/)
    rendered.should match(/value for message/)
    rendered.should match(/value for application/)
    rendered.should match(/value for environment/)
    rendered.should match(/value for version/)
    rendered.should match(/value for controller/)
    rendered.should match(/value for action/)
    rendered.should match(/#{Regexp.escape(@now.to_s)}/)
  end

  describe "with empty values" do
    before(:each) do
      @event = assign(:event,
                      stub_model(Event,
                                 :id => 1,
                                 :to_param => 'value for to_param'))
    end
    
    it "not render attributes" do
      render
      rendered.should_not match(/value for title/)
      rendered.should_not match(/value for message/)
      rendered.should_not match(/value for application/)
      rendered.should_not match(/value for environment/)
      rendered.should_not match(/value for version/)
      rendered.should_not match(/value for controller/)
      rendered.should_not match(/value for action/)
    end
  end
end
