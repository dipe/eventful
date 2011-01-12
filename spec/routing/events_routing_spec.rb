require "spec_helper"

describe EventsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/accounts/1/events" }.should route_to(:controller => "events", :action => "index", "account_id"=>"1")
    end

    it "recognizes and generates #new" do
      { :get => "/accounts/1/events/new" }.should route_to(:controller => "events", :action => "new", "account_id"=>"1")
    end

    it "recognizes and generates #show" do
      { :get => "/accounts/1/events/1" }.should route_to(:controller => "events", :action => "show", :id => "1", "account_id"=>"1")
    end

    it "recognizes and generates #edit" do
      { :get => "/accounts/1/events/1/edit" }.should route_to(:controller => "events", :action => "edit", :id => "1", "account_id"=>"1")
    end

    it "recognizes and generates #create" do
      { :post => "/accounts/1/events" }.should route_to(:controller => "events", :action => "create", "account_id"=>"1")
    end

    it "recognizes and generates #update" do
      { :put => "/accounts/1/events/1" }.should route_to(:controller => "events", :action => "update", :id => "1", "account_id"=>"1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/accounts/1/events/1" }.should route_to(:controller => "events", :action => "destroy", :id => "1", "account_id"=>"1")
    end

  end
end
