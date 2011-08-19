require "spec_helper"

describe "users/sessions/new.html.haml" do

  let(:user) do
    User.new
  end

  before do
    assign(:user, user)
    view.stubs(:t).with(".title").returns("Sign In")
    view.stubs(:t).with(".login_failed").returns("Login Failed")
    view.stubs(:resource).returns(user)
    view.stubs(:resource_name).returns('user')
    view.stubs(:devise_mapping).returns(Devise.mappings[:user])
    stub_template("devise/shared/_links" => "<span>Rendered links</span>")
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("h3", :text => "Sign In") }
  it { should have_selector("div#login_result") }
  it { should have_selector("form[data-remote=true]") }
  [ :nickname, :password, :remember_me ].each do |field|
    it { should have_selector("label", :for => field) }
    it { should have_selector("input", :name => "lalal") }
  end
  it { should have_selector("span", :text => "Rendered links") }
end
