require 'spec_helper'

describe Album do
  it "can be instantiated" do
    FactoryGirl.build(:album).should be_an_instance_of(Album)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:album).should be_persisted
  end

  it "requires a name" do
    Album.create.should have(1).errors_on(:name)
  end

  it "does not accept an already existing name" do
    FactoryGirl.create(:album)
    a = User.first.albums.build(:name => Album.first.name)
    a.save
    a.should have(1).errors_on(:name)
  end

  it "responds on title and return the name" do
    a = FactoryGirl.create(:album)
    a.title.should equal(a.name)
  end

  it "responds on random_photo and returns nil if it does not have any photos" do
    a = FactoryGirl.create(:album)
    a.photos.length.should equal(0)
    a.random_photo.should be_nil
  end

  it "responds on random_photo and returns a photo if it has at least one photos" do
    a = FactoryGirl.create(:album)
    FactoryGirl.create_list(:photo, 10, :album_id => a.id)
    a.photos.length.should equal(10)
    a.random_photo.should be_an_instance_of(Photo)
  end

  it "does not accept a date_start which is after date_end" do
    a = FactoryGirl.build(:album, :date_end => 1.year.ago, :date_start => Time.now)
    a.save
    a.should have(1).errors_on(:date_end)
  end

end
