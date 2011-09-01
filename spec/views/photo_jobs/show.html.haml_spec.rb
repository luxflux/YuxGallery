require 'spec_helper'

describe "photo_jobs/show.html.haml" do
  before(:each) do
    @photo_job = assign(:photo_job, stub_model(PhotoJob))
  end

  it "renders attributes in <p>" do
    render
  end
end
