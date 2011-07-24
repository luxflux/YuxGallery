require 'spec_helper'

describe User do
  it "can be instantiated" do
    FactoryGirl.build(:user).should be_an_instance_of(User)
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
  end
end 
