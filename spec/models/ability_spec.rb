require 'spec_helper'

describe Ability do
  before do
    @user = FactoryGirl.create(:user)
    @ability = Ability.new(@user)
  end

  subject do
    @ability
  end

  # everyone should be able to list the users
  it { should be_able_to(:index, User) }
  
  # only the user himself is allowed to edit his profile
  [ :edit, :update ].each do |action|
    it { should_not be_able_to(action, User.new) }
    it { should be_able_to(action, @user) }
  end

  # only an admin can delete a user
  it { should_not be_able_to(:destroy, User) }

end 
