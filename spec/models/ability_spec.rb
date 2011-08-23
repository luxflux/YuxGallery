require 'spec_helper'

describe Ability do
  context "as a guest" do
    before do
      @user = stub_model(User).as_new_record
      @ability = Ability.new(@user)
    end

    subject do
      @ability
    end

    context "on User" do
      # everyone should be able to list the users
      it { should be_able_to(:index, User) }

      # only the user himself is allowed to edit his profile
      [ :edit, :update ].each do |action|
        it { should_not be_able_to(action, User) }
      end

      # only an admin can delete a user
      it { should_not be_able_to(:destroy, User) }

      # only a user can list his folders
      it { should_not be_able_to(:folders, User) }
    end

    context "on Album" do
      # everyone should be able to list the albums
      it { should be_able_to(:index, Album) }

      # only users and admins can create albums
      [ :new, :create ].each do |action|
        it { should_not be_able_to(action, Album) }
      end

      # only the owner is allowed to edit and destroy an album
      [ :edit, :update, :destroy ].each do |action|
        it { should_not be_able_to(action, Album) }
      end
    end

    context "on Scan" do
      # a guest should not be able to do anything on Scan
      [ :index, :show, :new, :create, :edit, :update, :destroy ].each do |action|
        it { should_not be_able_to(action, Scan) }
      end
    end
    
    context "on Photo" do
      # a guest should be able to read the photo
      [ :show, :index ].each do |action|
        it { should be_able_to(action, Photo) }
      end

      # a guest should not be able to manage a photo
      [ :new, :create, :edit, :update, :destroy ].each do |action|
        it { should_not be_able_to(action, Photo) }
      end
    end
  end

  context "as a user" do
    before do
      @user = stub_model(User, :role => :user)
      @ability = Ability.new(@user)
    end

    subject do
      @ability
    end

    context "on User" do
      # everyone should be able to list the users
      it { should be_able_to(:index, User) }

      # the user is allowed to edit his profile
      [ :edit, :update ].each do |action|
        it { should be_able_to(action, @user) }
      end

      # only an admin can delete a user
      it { should_not be_able_to(:destroy, User) }

      # only a user can list his folders
      it { should be_able_to(:folders, User) }
    end
    
    context "on Album" do
      # everyone should be able to list the albums
      it { should be_able_to(:index, Album) }

      # only users and admins can create albums
      [ :new, :create ].each do |action|
        it { should be_able_to(action, Album) }
      end
      
      # only the owner is allowed to edit and destroy an album
      [ :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, FactoryGirl.create(:album, :user => @user)) }
      end
    end

    context "on Scan" do
      # the user can manage the scan if the album which owns the scan belongs to him
      [ :index, :show, :new, :create, :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, stub_model(Scan, :album => stub_model(Album, :user => @user))) }
        it { should_not be_able_to(action, stub_model(Scan)) }
      end
    end
    
    context "on Photo" do
      # the user can manage the photo if the album which owns the photo belongs to him
      [ :index, :show, :new, :create, :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, stub_model(Photo, :album => stub_model(Album, :user => @user))) }
      end
      [ :new, :create, :edit, :update, :destroy ].each do |action|
        it { should_not be_able_to(action, stub_model(Photo)) }
      end
    end
  end

  context "as an admin" do
    before do
      @user = stub_model(User, :role => :admin)
      @ability = Ability.new(@user)
    end

    subject do
      @ability
    end

    context "on User" do
      # everyone should be able to list the users
      it { should be_able_to(:index, User) }

      # the user is allowed to edit his profile
      [ :edit, :update ].each do |action|
        it { should be_able_to(action, @user) }
      end

      # only an admin can delete a user
      it { should be_able_to(:destroy, User) }

      # only a user can list his folders
      it { should be_able_to(:folders, User) }
    end
    
    context "on Album" do
      # everyone should be able to list the albums
      it { should be_able_to(:index, Album) }

      # only users and admins can create albums
      [ :new, :create ].each do |action|
        it { should be_able_to(action, Album) }
      end
      
      # only the owner is allowed to edit and destroy an album
      [ :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, FactoryGirl.create(:album, :user => @user)) }
      end
    end
    
    context "on Scan" do
      # an admin can manage the scan if the album which owns the scan belongs to him
      [ :index, :show, :new, :create, :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, stub_model(Scan, :album => stub_model(Album, :user => @user))) }
        it { should_not be_able_to(action, stub_model(Scan)) }
      end
    end
    
    context "on Photo" do
      # the user can manage the photo if the album which owns the photo belongs to him
      [ :index, :show, :new, :create, :edit, :update, :destroy ].each do |action|
        it { should be_able_to(action, stub_model(Photo, :album => stub_model(Album, :user => @user))) }
      end
      [ :new, :create, :edit, :update, :destroy ].each do |action|
        it { should_not be_able_to(action, stub_model(Photo)) }
      end
    end
  end
end
