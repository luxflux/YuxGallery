require 'spec_helper'

describe "photo_jobs/edit.html.haml" do
  before(:each) do
    @photo_job = assign(:photo_job, stub_model(PhotoJob))
  end

  it "renders the edit photo_job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => photo_jobs_path(@photo_job), :method => "post" do
    end
  end
end
