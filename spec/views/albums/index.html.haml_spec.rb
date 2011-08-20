require "spec_helper"

describe "albums/index.html.haml" do
  before do
    @user = stub_model(User, :title => "Testuser")
    @album = stub_model(Album, :user => @user)
    @albums = []
    assign(:user, @user)
    assign(:album, @album)
  end

  context "with multiple albums" do
    before do
      4.times do
        @albums << stub_model(Album, :user => @user)
      end
      assign(:albums, @albums)
    end

    context "and they belong to the logged in user" do
      before do
        view.expects(:t).with(".current_user.link", :count => 4).returns("Linktext")
        view.expects(:t).with(".current_user.there_are_albums", :count => 4).returns("You have 4 albums")
        view.expects(:current_user).returns(@user)
        stub_template("shared/_photo_collection" => "rendered collection")
        render
      end
 
      subject do
        rendered
      end

      it { should match(/rendered collection/) }
    end

    context "and they don't belong to the logged in user" do
      it "should render another text" do
        view.expects(:current_user).returns(stub_model(User))
        view.expects(:t).with(".other_user.there_are_albums", :count => 4, :user => "Testuser").returns("User Testuser has 4 albums")
        render
      end
    end
  end
end
