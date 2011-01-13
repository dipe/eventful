require 'spec_helper'

describe "accounts/show.html.erb" do
  before(:each) do
    @account = assign(:account,
                      stub_model(Account,
                                 :id => 'value for to_params',
                                 :name => "value for name"
                                 ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
