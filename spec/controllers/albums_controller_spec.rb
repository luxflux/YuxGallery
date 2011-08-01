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

  end

end
