require 'spec_helper'

describe PhotoJob do
  it "responds to job" do
    lambda { PhotoJob.new.job }.should_not raise_error(NoMethodError)
  end
  it "responds to scan" do
    lambda { PhotoJob.new.scan }.should_not raise_error(NoMethodError)
  end
  it "responds on state" do
    lambda { PhotoJob.new.state }.should_not raise_error(NoMethodError)
  end

  it "returns a successful state if the job does not exist anymore" do
    PhotoJob.new.state.should eq(:success)
  end

  it "returns queued if the job has not been started yet" do
    PhotoJob.any_instance.stubs(:job).returns(Delayed::Job.new(:failed_at => nil, :locked_by => nil))
    PhotoJob.new.state.should eq(:queued)
  end

  it "returns failed if the job has failed" do
    PhotoJob.any_instance.stubs(:job).returns(Delayed::Job.new(:failed_at => Time.now))
    PhotoJob.new.state.should eq(:failed)
  end
end
