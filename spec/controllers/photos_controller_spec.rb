require "spec_helper"

describe PhotosController do

  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @photo = FactoryGirl.create(:photo, :album_id => @album.id)
    # we have to stub out the PhotoUploader, otherwhise to_xml fails, but only in the tests
    Photo.any_instance.stubs(:photo).returns(true)
  end

  describe "GET index" do
    context "with a HTML request" do
      before do
        get :index, :user_id => @user.id, :album_id => @album.id
      end

      it "assigns @photos" do
        assigns(:photos).should eq([@photo])
      end

      it "renders the index template" do
        response.should render_template("index")
      end
    end

    context "with a XML request" do
      before do
        get :index, :user_id => @user.id, :album_id => @album.id, :format => :xml
      end

      it "renders @photos as XML" do
        response.content_type.should eq("application/xml")
      end
    end
  end

end
