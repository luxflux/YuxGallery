require "spec_helper"

describe "shared/_photo_collection.html.haml" do
  context "without something to render" do
    before do
      view.should_receive(:coll).any_number_of_times.and_return([])
      render
    end

    it "renders the list definition" do
      rendered.should have_selector("ul", :class => "photo_collection")
    end
    
    it "renders no list entries" do
      rendered.should_not have_selector("li")
    end
  end

  context "with a user to render" do
    before do
      @user = FactoryGirl.create(:user)
      view.should_receive(:coll).any_number_of_times.and_return([@user])
      render
    end

    it "renders the list definition" do
      rendered.should have_selector("ul", :class => "photo_collection")
    end

    it "renders the user as list entry" do
      rendered.should have_selector("li", :content => @user.nickname)
    end
  end
end
