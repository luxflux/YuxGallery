require 'spec_helper'

describe "photo_jobs/index.html.haml" do
  before(:each) do
    assign(:photo_jobs, [
      stub_model(PhotoJob),
      stub_model(PhotoJob)
    ])
  end

  it "renders a list of photo_jobs" do
    render
  end
end
