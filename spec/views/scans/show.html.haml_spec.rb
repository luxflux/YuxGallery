require "spec_helper"

describe "scans/show.html.haml" do
  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @scan = stub_model(Scan, :album_id => @album.id)
    assign(:user, @user)
    assign(:album, @album)
    assign(:scan, @scan)
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("form#scan_progress") }
  it { should have_selector("script", :text => /uploader = new Uploader/) }
end
