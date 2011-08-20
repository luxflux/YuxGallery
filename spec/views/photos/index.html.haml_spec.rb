require "spec_helper"

describe "photos/index.html.haml" do
  before do
    @user = stub_model(User)
    @album = stub_model(Album, :user => @user)
    @photos = []
    assign(:user, @user)
    assign(:album, @album)
    view.expects(:content_for).with(:title, "#{@user.title} / #{@album.title}").returns("#{@user.title} / #{@album.title}")
  end

  context "without a photo" do
    before do
      assign(:photos, @photos)
      view.expects(:t).with(".this_album_has_photos", :count => 0).returns("This album doesn't have a photo")
      view.expects(:content_for).with(:actions).returns("New Photo<br />New Scan")
      view.expects(:current_user).returns(@user)
      render
    end
   
    subject do
      rendered
    end
    it { should_not have_selector("ul.rui-tabs-carousel") }
    it { should_not have_selector("ul.rui-tabs-carousel ul") }
    it { should_not have_selector("ul.rui-tabs-carousel ul li a img") }

  end
  
  context "with multiple photos" do
    before do
      4.times do
        @photos << stub_model(Photo, :album => @album)
      end
      assign(:photos, @photos)
    end

    context "and they belong to the logged in user" do
      before do
        view.expects(:t).with(".this_album_has_photos", :count => 4).returns("This album has 4 photos")
        view.expects(:content_for).with(:actions).returns("New Photo<br />New Scan")
        view.expects(:current_user).returns(@user)
        render
      end
 
      subject do
        rendered
      end

      it { should have_selector("ul.rui-tabs-carousel") }
      it { should have_selector("ul.rui-tabs-carousel ul") }
      it { should have_selector("ul.rui-tabs-carousel ul li a img", :count => 4) }
    end

    context "and they don't belong to the logged in user" do
      it "should not render the actions for this album" do
        view.expects(:content_for).with(:actions).never
        view.expects(:current_user).returns(stub_model(User))
        render
      end
    end
  end
end
