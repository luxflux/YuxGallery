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
        it { should_not be_able_to(action, User.new) }
      end

      # only an admin can delete a user
      it { should_not be_able_to(:destroy, User) }

      # only a user can list his folders
      it { should_not be_able_to(:folders, User) }
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
  end
end