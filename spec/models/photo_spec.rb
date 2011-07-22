require 'spec_helper'

describe Photo do
  it "can be instantiated" do
    FactoryGirl.build(:photo).should be_an_instance_of(Photo)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:photo).should be_persisted
  end
  
  it "requires a name" do
    Photo.create.should have(1).errors_on(:name)
  end

  it "responds on title and returns the name" do
    p = FactoryGirl.create(:photo)
    p.title.should equal(p.name)
  end

  it "returns the user which owns this album when calling user" do
    u = FactoryGirl.create(:user)
    a = FactoryGirl.create(:album, :user_id => u.id)
    FactoryGirl.create(:photo, :album_id => a.id).user.should be_an_instance_of(User)
  end

  it "can read the exif data from its photo" do
    FactoryGirl.create(:photo).exif_data[:software].should == "MySoftware 1.2"
  end

  it "can overwrite its attributes from the exif data" do
    p = FactoryGirl.create(:photo, :name => "Photo1", :shot_at => 1.year.ago, :description => "Testing")
    p.set_from_exif!
    p.name.should == "test.png"
    p.shot_at.should == Time.parse("01/01/2011")
    p.description.should == "Created with Testcam, edited with MySoftware 1.2"
  end

  it "can fill up missing attributes from the exif data" do
    p = FactoryGirl.create(:photo, :name => "Photo1", :shot_at => Time.parse("02/02/2002")) # we dont set description
    p.set_from_exif
    p.name.should == "Photo1"
    p.shot_at.should == Time.parse("02/02/2002")
    p.description.should == "Created with Testcam, edited with MySoftware 1.2"

  end

end
