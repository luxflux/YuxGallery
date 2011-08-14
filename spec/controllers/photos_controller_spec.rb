require "spec_helper"

describe PhotosController do

  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @photo = FactoryGirl.create(:photo, :album_id => @album.id)
    # we have to stub out the PhotoUploader, otherwhise to_xml fails, but only in the tests
    Photo.any_instance.stubs(:photo).returns(true)
    Photo.any_instance.stubs(:set_from_exif).returns(true)
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

  describe "GET show" do
    context "with a HTML request" do
      before do
        get :show, :user_id => @user.id, :album_id => @album.id, :id => @photo.id
      end

      it "assigns @photo" do
        assigns(:photo).should eq(@photo)
      end

      it "renders the show template" do
        response.should render_template("show")
      end
    end

    context "with a XML request" do
      before do
        get :show, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :format => :xml
      end

      it "renders @photo as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "GET new" do
    context "with a HTML request" do
      before do
        get :new, :user_id => @user.id, :album_id => @album.id
      end

      it "assigns @photo" do
        assigns(:photo).should be_instance_of(Photo)
        assigns(:photo).should_not be_persisted
      end

      it "renders the new template" do
        response.should render_template("new")
      end
    end

    context "with a XML request" do
      before do
        get :new, :user_id => @user.id, :album_id => @album.id, :format => :xml
      end

      it "renders @photo as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "GET edit" do
    context "with a HTML request" do
      before do
        get :edit, :user_id => @user.id, :album_id => @album.id, :id => @photo.id
      end

      it "assigns @photo" do
        assigns(:photo).should eq(@photo)
      end

      it "renders the edit template" do
        response.should render_template("edit")
      end
    end

    context "with a XML request" do
      before do
        get :edit, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :format => :xml
      end

      it "renders @photo as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "POST create" do
    before do
      sign_in @user
    end
    context "with a HTML request" do
      context "with valid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :photo => { :name => "test" }
        end

        subject do
          assigns(:photo)
        end
        it { should be_instance_of(Photo) }
        it { should be_persisted }

        it "redirects to the photo" do
          response.should redirect_to(user_album_photo_path(@user, @album, assigns(:photo)))
        end
      end

      context "with invalid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :photo => { }
        end

        subject do
          assigns(:photo)
        end
        it { should have(1).errors_on(:name) }

        it "renders the new template" do
          response.should render_template("new")
        end
      end
    end
  end

end
