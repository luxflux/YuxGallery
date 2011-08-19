require "spec_helper"

describe "users/_form.html.haml" do
  context "with an existing user" do
    before do
      @user = FactoryGirl.create(:user)
      assign :user, @user
      render
    end
   
    subject do
      rendered
    end
    it { should have_selector("form", :action => edit_user_path(@user), :"data-remote" => "true") }
    it { should have_selector("fieldset") }
    it { should have_selector("legend", :contains => "Edit") }
    [ :nickname, :email ].each do |field|
      it { should have_selector("label[for=user_#{field}]") }
      it { should have_selector("input#user_#{field}") }
    end
    it { should have_selector("input[type=submit]") }
  end
end
