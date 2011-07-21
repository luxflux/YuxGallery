require 'spec_helper'

describe Photo do
  it "can be instantiated" do
    FactoryGirl.build(:photo).should be_an_instance_of(Photo)
  end

  it "can be saved successfully" do
    PhotoUploader.any_instance.stubs(:get_exif_data).returns({
      :date_time_original => Time.now
    })
    FactoryGirl.create(:photo).should be_persisted
  end
end
