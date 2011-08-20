require "spec_helper"

describe "scans/index.html.haml" do
  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @scan = stub_model(Scan, :album_id => @album.id)
    assign(:user, @user)
    assign(:album, @album)
    assign(:scans, [@scan])
    view.expects(:t).with(".title").returns("Listing scans")
    view.expects(:t).with(".show").returns("Show scan")
    view.expects(:t).with(".edit").returns("Edit scan")
    view.expects(:t).with(".destroy.text").returns("Destroy scan")
    view.expects(:t).with(".destroy.confirm").returns("Are you sure?")
    view.expects(:t).with(".new").returns("New Scan")
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("h1", :text => "Listing scans") }
  it { should have_selector("table") }
  [ "Show", "Edit", "Destroy" ].each do |action|
    it { should have_selector("td a", :text => action) }
  end
  it { should have_selector("a", :text => "New Scan") }
end
