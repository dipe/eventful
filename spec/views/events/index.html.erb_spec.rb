require 'spec_helper'

describe "events/index.html.erb" do
  before(:each) do
    @now = Time.now
    events = [stub_model(Event,
                         :action => "value for action",
                         :created_at => @now,
                         :to_param => 'value for to_param1'
                         ),
              stub_model(Event,
                         :action => "value for action",
                         :created_at => @now,
                         :to_param => 'value for to_param2'
                         )
             ]
    events.stub!(:total_pages).and_return(0)
    assign(:events, events)
    assign(:account, stub_model(Account,
                                :application => "value for application",
                                :to_param => 'value for to_param'))
  end

  it "renders a list of events" do
    render
    assert_select "span", :text => "value for action".to_s, :count => 2
  end
end
