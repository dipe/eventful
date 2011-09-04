require 'spec_helper'

describe "Events" do
  describe "GET /events" do
    before(:each) do
      @event = Event.create(:account_id => 'value for account_id')
      @account = Account.create(:application => 'value for application')
    end
    
    it "works! (now write some real specs)" do
      get "/accounts/#{@account.id}/events"
    end
  end
end
