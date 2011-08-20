require "spec_helper"

describe "photos/show.html.haml" do
  before do
    @user = stub_model(User)
    @album = stub_model(Album, :user => @user)
    @photo = stub_model(Photo, :album => @album, :name => "Testimage", :description => "taken yesterday")
    assign(:user, @user)
    assign(:album, @album)
    assign(:photo, @photo)
    @photo.photo.lightbox400.expects(:url).returns("file.jpg")
    @photo.photo.lightbox800.expects(:url).returns("file.jpg")
  end
  
  context "with the user who owns the photo" do
    before do
      view.expects(:current_user).at_least_once.returns(@user)
      render
    end
 
    subject do
      rendered
    end

    it { should have_selector("div.photo") }
    it { should have_selector("div.photo div.description") }
    it { should have_selector("div.photo div.description p", :count => 3) }
    it { should have_selector("div.photo div.description p span + a", :count => 2) }
    it { should have_selector("div.photo div.description p", :text => /#{@photo.shot_at}/) }
    it { should have_selector("div.photo div.image") }
    it { should have_selector("div.photo div.image a img", :count => 2) }
    it { should have_selector("div.photo div.image script", :text => /set_lightbox_image_which_fits/) }
    it { should have_selector("div.photo + div.clear") }
  end

  context "with another user" do
    before do
      other_user = stub_model(User)
      view.expects(:current_user).at_least_once.returns(other_user)
      render
    end

    subject do
      rendered
    end
    it { should_not have_selector("div.photo div.description p span + a") }
  end
end
