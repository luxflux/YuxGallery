require "spec_helper"

describe ScansController do
 
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user, :role => :user)
    @album = FactoryGirl.create(:album, :user => @user)
    @scan = FactoryGirl.build(:scan, :album => @album)
    FileUtils.mkdir(@scan.fullpath)
    @scan.save
    sign_in @user
  end

  after do
    FileUtils.rm_rf(@scan.fullpath)
  end

  describe "GET index" do
    context "with a HTML request" do
      before do
        get :index, :user_id => @user.id, :album_id => @album.id
      end

      it "assigns @scans" do
        assigns(:scans).should eq([@scan])
      end

      it "renders the index template" do
        response.should render_template("index")
      end
    end

    [ :xml, :json ].each do |format|
      context "with a #{format.to_s.upcase} request" do
        before do
          get :index, :user_id => @user.id, :album_id => @album.id, :format => format
        end

        it "assigns @scans" do
          assigns(:scans).should eq([@scan])
        end

        it "renders @scans as #{format}" do
          response.content_type.should eq("application/#{format}")
        end
      end
    end
  end

  describe "GET show" do
    context "with a HTML request" do
      before do
        get :show, :user_id => @user.id, :album_id => @album.id, :id => @scan.id
      end
      
      it "assigns @scan" do
        assigns(:scan).should eq(@scan)
      end

      it "renders the show template" do
        response.should render_template("show")
      end
    end

    [ :xml, :json ].each do |format|
      context "with a #{format.to_s.upcase} request" do
        before do
          get :show, :user_id => @user.id, :album_id => @album.id, :id => @scan.id, :format => format
        end
  
        it "renders @scans.status as #{format}" do
          response.content_type.to_s.should eq("application/#{format}")
        end
      end
    end
  end

  describe "GET new" do
    context "with a HTML request" do
      before do
        get :new, :user_id => @user.id, :album_id => @album.id
      end

      it "assigns @scan" do
        assigns(:scan).should be_instance_of(Scan)
        assigns(:scan).should_not be_persisted
      end

      it "renders the new template" do
        response.should render_template("new")
      end
    end

    [ :xml, :json ].each do |format|
      context "with a #{format.to_s.upcase} request" do
        before do
          get :new, :user_id => @user.id, :album_id => @album.id, :format => format
        end

        it "renders @scan as #{format}" do
          response.content_type.to_s.should eq("application/#{format}")
        end
      end
    end
  end

  describe "POST create" do
    context "with a HTML request" do
      context "and valid params" do
        before do
          Scan.any_instance.stubs(:validate_directory).returns(true)
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "/test" }
        end
    
        subject do
          assigns(:scan)
        end
        it { should be_instance_of(Scan) }
        it { should be_valid(Scan) }
        it { should be_persisted }

        it "redirects to the scan" do
          response.should redirect_to(scan_path(assigns(:scan)))
        end
      end

      context "and invalid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "../test" }
        end

        subject do
          assigns(:scan)
        end
        it { should have(3).errors_on(:directory) }
  
        it "ensures that directory is not a fullpath" do
          assigns(:scan).directory.should eq("../test")
        end

        it "renders the new template" do
          response.should render_template("new")
        end
      end
    end

    context "with a XML request" do
      context "and valid params" do
        before do
          Scan.any_instance.stubs(:validate_directory).returns(true)
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "/test" }, :format => :xml
        end

        it "renders the new created Scan as xml" do
          response.content_type.should eq("application/xml")
        end
      end

      context "and invalid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "../test" }, :format => :xml
        end

        it "renders the errors on the model" do
          response.content_type.should eq("application/xml")
          response.response_code.should eq(422)
        end
      end
    end

    context "with a JS request" do
      context "and valid params" do
        before do
          Scan.any_instance.stubs(:validate_directory).returns(true)
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "/test" }, :format => :js
        end

        it "uses lightbox to load the path to new scan" do
          response.body.should eq("Lightbox.load('#{scan_path(assigns(:scan))}');")
        end
      end

      context "and invalid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "../test" }, :format => :js
        end

        it "renders the errors in the lightbox" do
          response.content_type.should eq("text/javascript")
          response.should render_template("update_lightbox_with_errors_for")
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "with a HTML request" do
      before do
        delete :destroy, :user_id => @user.id, :album_id => @album.id, :id => @scan.id
      end

      it "removes the given Scan" do
        Scan.all.length.should eq(0)
      end

      it "redirects to the overview of the scans" do
        response.should redirect_to(album_scans_path(@album))
      end
    end

    context "with a XML request" do
      before do
        delete :destroy, :user_id => @user.id, :album_id => @album.id, :id => @scan.id, :format => :xml
      end

      it "removes the given Scan and replies with a successful state" do
        Scan.all.length.should eq(0)
        response.should be_success
      end
    end
  end
end
