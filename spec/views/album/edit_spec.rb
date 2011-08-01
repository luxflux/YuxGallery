require "spec_helper"

describe "albums/edit.html.erb" do
  it "displays the edit form for an album" do
    user = FactoryGirl.create(:user)
    assign(:album, FactoryGirl.create(:album, :user_id => user))

    render

    rendered.should =~ /Editing album/
    rendered.should =~ /Date start/
    rendered.should =~ /Date end/
    rendered.should =~ /Show/
  end
end
