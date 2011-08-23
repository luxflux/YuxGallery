require "spec_helper"

describe PhotosController do

  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user, :role => :user)
    @album = FactoryGirl.create(:album, :user => @user)
    @photo = FactoryGirl.create(:photo, :album => @album)
    # we have to stub out the PhotoUploader, otherwhise to_xml fails, but only in the tests
    Photo.any_instance.stubs(:mount_uploader).returns(true)
    Photo.any_instance.stubs(:set_from_exif).returns(true)
    sign_in @user
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
          response.should redirect_to(photo_path(assigns(:photo)))
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

    context "with a XML request" do
      context "with valid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :photo => { :name => "test" }, :format => :xml
        end

        it "renders the new Photo as xml" do
          response.content_type.should eq("application/xml")
        end
      end

      context "with invalid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :photo => { }, :format => :xml
        end

        it "renders the errors as xml" do
          response.content_type.should eq("application/xml")
        end

        it "has not a successful reply state" do
          response.should_not be_success
          response.response_code.should eq(422)
        end
      end
    end
  end

  describe "PUT update" do
    context "with a HTML request" do
      context "and valid params" do
        before do
          put :update, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :photo => { :name => "test" }
        end

        it "assigns @photo with the Photo which should be changed" do
          assigns(:photo).should eq(@photo)
        end

        it "updates the Photo with the new attribute" do
          @photo.name.should_not eq("test")
          @photo.reload.name.should eq("test")
        end
      end

      context "and invalid params" do
        before do
          put :update, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :photo => { :name => nil }
        end

        subject do
          assigns(:photo)
        end
        it { should have(1).errors_on(:name) }

        it "renders the edit template" do
          response.should render_template("edit")
        end
      end
    end

    context "with a XML request" do
      context "and valid params" do
        before do
          put :update, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :photo => { :name => "test" }, :format => :xml
        end

        it "has a successful response code" do
          response.should be_success
        end
      end

      context "and invalid params" do
        before do
          put :update, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :photo => { :name => nil }, :format => :xml
        end

        it "renders the errors on @photo as xml" do
          response.content_type.should eq("application/xml")
        end

        it "has a unsuccessful response code" do
          response.should_not be_success
          response.response_code.should eq(422)
        end
      end
    end

    context "with a JS request" do
      context "and valid params" do
        before do
          put :update, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :photo => { :name => "test" }, :format => :js
        end

        it "replies with the new value in the body" do
          response.body.should eq("test")
        end

        it "replies with xhr content" do
          response.content_type.to_s.should eq("text/javascript")
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "with a HTML request" do
      before do
        delete :destroy, :user_id => @user.id, :album_id => @album.id, :id => @photo.id
      end

      it "assigns @photo with the photo which should be deleted" do
        assigns(:photo).should eq(@photo)
      end

      it "removes the specified photo" do
        lambda { Photo.find(@photo.id) }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects to the photos collection" do
        response.should redirect_to(album_photos_path(@album))
      end
    end

    context "with a XML request" do
      before do
        delete :destroy, :user_id => @user.id, :album_id => @album.id, :id => @photo.id, :format => :xml
      end

      it "renders a success" do
        response.should be_success
      end

      it "renders XML" do
        response.content_type.should eq("application/xml")
      end
    end
  end

end
