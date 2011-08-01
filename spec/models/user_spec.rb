require 'spec_helper'

describe User do
  it "can be instantiated" do
    FactoryGirl.build(:user).should be_an_instance_of(User)
  end

  it "wants at least three alphanumeric signs as username" do
    u = FactoryGirl.build(:user, :nickname => "--a-")
    u.save
    u.should have(1).errors_on(:nickname)
  end
  
  it "does not allow .. as username" do
    u = FactoryGirl.build(:user, :nickname => "../test/")
    u.save
    u.should have(1).errors_on(:nickname)
  end

  context "which has been saved" do
    before do
      @user = FactoryGirl.create(:user) 
    end

    it "can be saved successfully" do
      @user.should be_persisted
    end

    it "creates an folder after beeing saved" do
      File.directory?(@user.sftp_folder).should be_true
    end

    it "removes the sftp folder after beeing destroyed" do
      @user.destroy
      File.directory?(@user.sftp_folder).should be_false
    end

    it "renames the sftp folder when a user gets renamed" do
      sftp_folder = @user.sftp_folder
      @user.nickname = "OtherUser"
      @user.save
      @user.sftp_folder.should_not == sftp_folder
      File.directory?(@user.sftp_folder).should be_true
    end

    it "returns a random photo on random_photo" do
      album = FactoryGirl.create(:album, :user_id => @user.id)
      photo = FactoryGirl.create(:photo, :album_id => album.id)
      @user.random_photo.should eq(photo)
    end

    it "responds on title and returns the nickname" do
      @user.title.should eq(@user.nickname)
    end

  end
end 
