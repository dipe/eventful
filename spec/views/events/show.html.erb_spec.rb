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
                               :controller => "value for controller",
                               :action => "value for action",
                               :request_url => "value for request_url",
                               :session_id => "value for session_id",
                               :additional_data => [],
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
    rendered.should match(/value for controller/)
    rendered.should match(/value for action/)
    rendered.should match(/#{Regexp.escape(I18n.l(@now))}/)
  end

  describe "with empty values" do
    before(:each) do
      @event = assign(:event,
                      stub_model(Event,
                                 :application => nil,
                                 :id => 1,
                                 :created_at => @now,
                                 :to_param => 'value for to_param'))
    end
    
    it "not render attributes" do
      render
      rendered.should_not match(/value for title/)
      rendered.should_not match(/value for message/)
      rendered.should_not match(/value for application/)
      rendered.should_not match(/value for controller/)
      rendered.should_not match(/value for action/)
    end
  end
end
