require 'spec_helper'

describe UsersController do
  
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
  end
  
  describe "GET index" do
    context "with a HTML request" do
      before do
        get :index
      end

      it "assigns @users" do
        assigns(:users).should eq([@user])
      end

      it "renders the index template for an html request" do
        response.should render_template("index")
      end
    end

    context "with a XML request" do
      before do
        get :index, :format => :xml
      end
      
      it "renders @users as xml" do
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "GET edit" do
    before do
      get :edit, :id => @user.id
    end

    it "assigns @user" do
      assigns(:user).should eq(@user)
    end
  end

  describe "PUT update" do
    before do
      sign_in @user
    end

    context "with a HTML request" do
      it "updates the assigned user with the new params" do
        put :update, :id => @user.id, :user => { :nickname => "OtherUser" }
        @user.reload.nickname.should eq("OtherUser")
        response.should redirect_to(@user)
      end

      it "disallowes access to other users than the user himself" do
        user2 = FactoryGirl.create(:user)
        old_name = user2.nickname
        put :update, :id => user2.id, :user => { :nickname => "OtherUser" }
        user2.reload.nickname.should eq(old_name)
        response.should redirect_to(root_url)
      end

      it "renders the edit action if the params were not valid" do
        old_name = @user.nickname
        put :update, :id => @user.id, :user => { :nickname => "..test" }
        @user.reload.nickname.should eq(old_name)
        response.should render_template("edit")
      end
    end

    context "with a XML request" do
      it "updates the assigned user with the new params" do
        put :update, :id => @user.id, :user => { :nickname => "OtherUser" }, :format => :xml
        @user.reload.nickname.should eq("OtherUser")
        response.should be_success
      end
      
      it "disallowes access to other users than the user himself" do
        user2 = FactoryGirl.create(:user)
        old_name = user2.nickname
        put :update, :id => user2.id, :user => { :nickname => "OtherUser" }, :format => :xml
        user2.reload.nickname.should eq(old_name)
        response.response_code.should eq(405)
      end

      it "renders the errors as xml if the params were not valid" do
        old_name = @user.nickname
        put :update, :id => @user.id, :user => { :nickname => "..test" }, :format => :xml
        @user.reload.nickname.should eq(old_name)
        response.response_code.should eq(422)
      end
    end

    context "with a JS request" do
      it "updates the assigned user with the new params" do
        put :update, :id => @user.id, :user => { :nickname => "OtherUser" }, :format => :js
        @user.reload.nickname.should eq("OtherUser")
        response.should be_success
        response.body.should include("notice")
      end
      
      it "disallowes access to other users than the user himself" do
        user2 = FactoryGirl.create(:user)
        old_name = user2.nickname
        put :update, :id => user2.id, :user => { :nickname => "OtherUser" }, :format => :js
        user2.reload.nickname.should eq(old_name)
        response.should be_success
        response.body.should include("alert")
      end

      it "renews the form to display the errors" do
        old_name = @user.nickname
        put :update, :id => @user.id, :user => { :nickname => "..test" }, :format => :js
        @user.reload.nickname.should eq(old_name)
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do

  # TODO: user should be logged in to do this

    context "with a HTML request" do 
      before do
        delete :destroy, :id => @user.id
      end
      
      it "destroys the user" do
        User.all.length.should eq(0)
      end

      it "redirects to the users list" do
        response.should redirect_to(users_path)
      end
    end

    context "with a XML request" do
      before do
        delete :destroy, :id => @user.id, :format => :xml
      end

      it "renders success for xml requests" do
        response.should be_success
      end
    end
  end

  describe "GET folders" do
    [ :xml, :rightjs_ac ].each do |format|
      context "with a #{format.to_s.upcase} request" do
        before do
          get :folders, :id => @user.id, :search => "/test", :format => format
        end

        it "assigns @folders with the found folders" do
          assigns(:folders).should be_instance_of(Array)
        end

        it "renders the found folders as #{format}" do
          case format
          when :xml
            response.content_type.should eq("application/#{format}")
          when :rightjs_ac
            response.content_type.to_s.should eq("text/html")
          end
        end
      end
    end
  end

end
