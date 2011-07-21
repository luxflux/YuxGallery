require 'spec_helper'

describe Photo do
  it "can be instantiated" do
    FactoryGirl.build(:photo).should be_an_instance_of(Photo)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:photo).should be_persisted
  end
end
