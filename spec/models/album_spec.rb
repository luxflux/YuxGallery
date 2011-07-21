require 'spec_helper'

describe Album do
  it "can be instantiated" do
    FactoryGirl.build(:album).should be_an_instance_of(Album)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:album).should be_persisted
  end
end
