require 'spec_helper'

describe "accounts/index.html.erb" do
  before(:each) do
    assign(:accounts,
           [
            stub_model(Account,
                       :id => 'value for to_params',
                       :name => "value for name"
                       ),
            stub_model(Account,
                       :id => 'value for to_params',
                       :name => "value for name"
                       )
           ])
  end

  it "renders a list of accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "value for name".to_s, :count => 2
  end
end
