require 'spec_helper'

describe "accounts/show.html.erb" do
  before(:each) do
    @account = assign(:account,
                      stub_model(Account,
                                 :id => 'value for to_params',
                                 :application => "value for application"
                                 ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/value for application/)
  end
end
