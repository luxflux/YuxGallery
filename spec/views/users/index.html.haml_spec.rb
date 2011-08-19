require "spec_helper"

describe "users/index.html.haml" do
  context "with one user" do
    before do
      assign :users, [ FactoryGirl.create(:user) ]
      view.stubs(:t).with(".text1", { :count => 1 }).returns("We have one registered user")
      render
    end
   
    subject do
      rendered
    end
    it { should have_selector("p", :text => "We have one registered user") }
    it { should have_selector("ul.photo_collection") }
    it { should have_selector("a.with_photo") }
  end
end
