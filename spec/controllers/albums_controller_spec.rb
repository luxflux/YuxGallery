require "spec_helper"

describe AlbumsController do
  
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user, :role => :user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    sign_in @user
  end

  describe "GET index" do
    context "with a HTML request" do
      before do
        get :index, :user_id => @user.id
      end

      it "assigns @albums" do
        assigns(:albums).should eq([@album])
      end

      it "renders the index template for a html request" do
        response.should render_template("index")
      end
    end

    context "with an XML request" do
      before do
        get :index, :user_id => @user.id, :format => :xml
      end

      it "renders @albums as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end
  
  describe "GET new" do
    context "with a HTML request" do
      before do
        get :new, :id => @album.id, :user_id => @user.id
      end

      it "assigns @album" do
        assigns(:album).should be_instance_of(Album)
      end
    end

    context "with a XML request" do
      before do
        get :new, :id => @album.id, :user_id => @user.id, :format => :xml
      end

      it "renders @album as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "GET edit" do
    context "with a HTML request" do
      before do
        get :edit, :id => @album.id, :user_id => @user.id
      end

      it "assigns @album" do
        assigns(:album).should eq(@album)
      end
    end

    context "with a XML request" do
      before do
        get :edit, :id => @album.id, :user_id => @user.id, :format => :xml
      end

      it "renders @album as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "POST create" do
    context "with a HTML request" do
      it "creates @album" do
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }
        assigns(:album).should be_instance_of(Album)
        response.should redirect_to(album_photos_path(assigns(:album)))
      end

      it "shows the errors from the model" do
        post :create, :user_id => @user.id
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.should render_template("new")
      end
    end

    context "with a JS request" do
      it "creates @album" do
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }, :format => :js
        assigns(:album).should be_instance_of(Album)
        response.should redirect_to(album_photos_path(assigns(:album)))
        response.content_type.should eq("text/javascript")
      end
      
      it "shows the errors from the model" do
        post :create, :user_id => @user.id, :format => :js
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.content_type.should eq("text/javascript")
        response.should render_template("update_lightbox_with_errors_for")
      end
    end
  
    context "with a XML request" do
      after do
        response.content_type.should eq("application/xml")
      end

      it "creates @album" do
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }, :format => :xml
        assigns(:album).should be_instance_of(Album)
        response.should be_success
        response.content_type.should eq("application/xml")
      end
      
      it "shows the errors from the model" do
        post :create, :user_id => @user.id, :format => :js, :format => :xml
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.response_code.should eq(422)
      end
    end
  end
  
  describe "PUT update" do
    context "with a HTML request" do
      it "updates the album with the new params" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :name => "My Test Album Changed Name" }
        @album.reload.name.should eq("My Test Album Changed Name")
        response.should redirect_to(@album)
      end

      it "renders the edit action if the params were not valid" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :date_end => Time.now, :date_start => Time.now + 1.day }
        assigns(:album).should have(1).errors_on(:date_end)
        response.should render_template("edit")
      end
    end

    context "with a XML request" do
      after do
        response.content_type.should eq("application/xml")
      end

      it "updates the album with the new params" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :name => "My Test Album Changed Name" }, :format => :xml
        @album.reload.name.should eq("My Test Album Changed Name")
        response.should be_success
      end
      it "renders the errors on the album model" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :date_end => Time.now, :date_start => Time.now + 1.day }, :format => :xml
        assigns(:album).should have(1).errors_on(:date_end)
        response.response_code.should eq(422)
      end
    end
  end

  describe "DELETE destroy" do
    context "with a HTML request" do
      before do
        delete :destroy, :id => @album.id, :user_id => @user.id
      end

      it "removes the album" do
        Album.all.length.should eq(0)
      end

      it "redirects to the albums list" do
        response.should redirect_to(user_albums_path(@user))
      end
    end

    context "with a XML request" do
      before do
        delete :destroy, :id => @album.id, :user_id => @user.id, :format => :xml
      end

      after do
        response.content_type.should eq("application/xml")
      end

      it "removes the album" do
        Album.all.length.should eq(0)
      end

      it "should be successful request" do
        response.should be_success
      end

    end
  end

end
