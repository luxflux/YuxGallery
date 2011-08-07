require "spec_helper"

describe AlbumsController do
  
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
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
        sign_in @user
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }
        assigns(:album).should be_instance_of(Album)
        response.should redirect_to(user_album_photos_path(@user,assigns(:album)))
      end

      it "shows the errors from the model" do
        sign_in @user
        post :create, :user_id => @user.id
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.should render_template("new")
      end

#      it "requires a logged in user" do
#        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }
#        response.should redirect_to(root_path)
#        response.should render_template("unauthorized")
#      end
    end

    context "with a JS request" do
      it "creates @album" do
        sign_in @user
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }, :format => :js
        assigns(:album).should be_instance_of(Album)
        response.should redirect_to(user_album_photos_path(@user,assigns(:album)))
        response.content_type.should eq("text/javascript")
      end
      
      it "shows the errors from the model" do
        sign_in @user
        post :create, :user_id => @user.id, :format => :js
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.content_type.should eq("text/javascript")
        response.should render_template("update_lightbox_with_errors_for")
      end
    end
  
    context "with a XML request" do
      it "creates @album" do
        sign_in @user
        post :create, :user_id => @user.id, :album => { :name => "Testalbum" }, :format => :xml
        assigns(:album).should be_instance_of(Album)
        response.should be_success
        response.content_type.should eq("application/xml")
      end
      
      it "shows the errors from the model" do
        sign_in @user
        post :create, :user_id => @user.id, :format => :js, :format => :xml
        assigns(:album).should be_instance_of(Album)
        assigns(:album).should have(1).errors_on(:name)
        response.content_type.should eq("application/xml")
        response.response_code.should eq(422)
      end
    end
  end
  
  describe "PUT update" do
# TODO: add user auth
    context "with a HTML request" do
      it "updates the album with the new params" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :name => "My Test Album Changed Name" }
        @album.reload.name.should eq("My Test Album Changed Name")
        response.should redirect_to([@user,@album])
      end

#      it "allowes only the owner to edit the album" do
#        old_name = @album.name
#        user2 = FactoryGirl.create(:user)
#        sign_in user2
#        put :update, :id => @album.id, :user_id => @user.id, :album => { :name => "My Test Album Changed Name" }
#        @album.reload.name.should eq(old_name)
#        response.should redirect_to(root_url)
#      end

      it "renders the edit action if the params were not valid" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :date_end => Time.now, :date_start => Time.now + 1.day }
        assigns(:album).should have(1).errors_on(:date_end)
        response.should render_template("edit")
      end
    end

    context "with a XML request" do
      it "updates the album the new params" do
        put :update, :id => @album.id, :user_id => @user.id, :album => { :name => "My Test Album Changed Name" }, :format => :xml
        @album.reload.name.should eq("My Test Album Changed Name")
        response.should be_success
      end
#      it "renders the errors on the album model" do
#        put :update, :id => @album.id, :user_id => @user.id, :album => { :date_end => Time.now, :date_start => Time.now + 1.day }, :format => :xml
#      end
    end
  end

end
