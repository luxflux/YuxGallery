require 'spec_helper'

describe "photo_jobs/new.html.haml" do
  before(:each) do
    assign(:photo_job, stub_model(PhotoJob).as_new_record)
  end

  it "renders new photo_job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => photo_jobs_path, :method => "post" do
    end
  end
end
