require 'spec_helper'

describe Album do
  it "can be instantiated" do
    Album.new.should be_an_instance_of(Album)
  end

  it "can be saved successfully" do
    Album.create!.should be_persisted
  end
end
