require 'spec_helper'

describe Scan do
  it "can be instantiated" do
    FactoryGirl.build(:scan).should be_an_instance_of(Scan)
  end
  
  it "does not accept directories which dont exist and which arent directories" do
    s = FactoryGirl.build(:scan)
    s.save
    s.should have(2).errors_on :directory
  end

  context "which is already created" do
    before do
      @scan = FactoryGirl.build(:scan)
      FileUtils.mkdir(@scan.fullpath)
      @scan.save
    end

    after do
      FileUtils.rm_rf(@scan.fullpath)
    end

    it "can be saved successfully" do
      @scan.should be_persisted
    end

    it "calls run! after save which creates and calles the delayed job" do
      @scan.job.should be_an_instance_of(Delayed::Job)
    end

    it "fakes the upload-status reply for rightjs" do
      Delayed::Worker.new.work_off
      @scan.reload
      @scan.status.should == {
        :received => 0,
        :state => "done",
        :uuid => 1,
        :speed => 0,
        :started_at => @scan.status[:started_at],
        :size => 0
      }
    end

    it "responds on title and returns its id" do
      @scan.title.should eq(@scan.id)
    end
  end

end 
