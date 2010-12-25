require 'spec_helper'

describe Event do
  it "should initialize created_at to actual time" do
    Event.create.created_at.should be_within(1).of(DateTime.now)
  end

  it "should set the default level to 1" do
    Event.new.level.should == 1
  end
end
