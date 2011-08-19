require "spec_helper"

describe "scans/_form.html.haml" do
  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @scan = Scan.new(:album_id => @album.id)
    assign(:user, @user)
    assign(:album, @album)
    assign(:scan, @scan)
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("form.new_scan[data-remote=true]") }
  it { should have_selector("div#error_explanation") }
  [ :directory ].each do |field|
    it { should have_selector("label[for=scan_#{field}]") }
    it { should have_selector("input#scan_#{field}") }
  end
  it { should have_selector("div.actions input[type=submit]") }
end
