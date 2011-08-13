require "spec_helper"

describe ScansController do
 
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @scan = FactoryGirl.build(:scan, :album_id => @album.id)
    FileUtils.mkdir(@scan.fullpath)
    @scan.save
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
    let :current_user do
      @user
    end
    context "with a HTML request" do
      context "and valid params" do
        before do
          post :create, :user_id => @user.id, :album_id => @album.id, :scan => { :directory => "/test" }
        end
    
        subject do
          assigns(:scan)
        end
        it { should be_instance_of(Scan) }
        it { should be_valid?(Scan) }
        it { should be_persisted(Scan) }
      end
    end
  end
end
