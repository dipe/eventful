require 'spec_helper'

describe "accounts/new.html.erb" do
  before(:each) do
    assign(:account,
           stub_model(Account,
                      :name => 'value for name'
                      ).as_new_record)
  end

  it "renders new account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => accounts_path, :method => "post" do
      assert_select "input#account_name", :name => "account[name]"
    end
  end
end
