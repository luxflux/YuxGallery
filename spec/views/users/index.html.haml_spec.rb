require "spec_helper"

describe "users/index.html.haml" do
  context "with one user" do
    before do
      assign :users, [ FactoryGirl.create(:user) ]
      render
    end
   
    subject do
      rendered
    end
    it { should have_selector("p", :content => "We have one registered user") }
    it { should have_selector("div", :class => "photo_collection") }
    it { should have_selector("a", :class => "with_photo") }
  end
end
