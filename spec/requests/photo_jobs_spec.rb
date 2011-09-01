require 'spec_helper'

describe "PhotoJobs" do
  describe "GET /photo_jobs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get photo_jobs_path
      response.status.should be(200)
    end
  end
end
