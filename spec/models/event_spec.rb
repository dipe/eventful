require 'spec_helper'

describe Event do
  it "should initialize created_at to actual time" do
    Event.new.created_at.should be_within(1).of(DateTime.now)
  end
end
