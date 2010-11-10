require 'spec_helper'

describe "events/index.html.erb" do
  before(:each) do
    assign(:events,
           [
            stub_model(Event,
#                       :created_at => "value for created_at",
                       :node => "value for node",
                       :application => "value for application",
                       :environment => "value for environment",
                       :action => "value for action",
                       :title => "value for title",
                       :message => "value for message",
                       :is_a? => false,
                       :kind_of? => false
                       ),
            stub_model(Event,
#                       :created_at => "value for created_at",
                       :node => "value for node",
                       :application => "value for application",
                       :environment => "value for environment",
                       :action => "value for action",
                       :title => "value for title",
                       :message => "value for message",
                       :is_a? => false,
                       :kind_of? => false
                       )
           ])
  end

  it "renders a list of events" do
    render
 #   assert_select "tr>td", :text => "value for created_at".to_s, :count => 2
    assert_select "tr>td", :text => "value for application".to_s, :count => 2
    assert_select "tr>td", :text => "value for environment".to_s, :count => 2
    assert_select "tr>td", :text => "value for action".to_s, :count => 2
    assert_select "tr>td", :text => "value for message".to_s, :count => 2
    assert_select "tr>td", :text => "value for title".to_s, :count => 2
  end
end
