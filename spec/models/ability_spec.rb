require 'spec_helper'

describe Ability do
  before do
    user = FactoryGirl.create(:user)
    @ability = Ability.new(user)
  end

  subject do
    @ability
  end

  it { should be_able_to(:index, User) }
end 
