require "spec_helper"

describe "shared/_update_lightbox_with_errors_for.js.haml" do
  before do
    @user = stub_model(User)
    assign(:user, @user)
    view.expects(:model).returns(@user)
    render
  end
  
  subject do
    rendered
  end

  it { should match(/\$\('error_explanation'\).replace/) }
  it { should match(/\$\('error_explanation'\).show\(\)/) }
  it { should match(/Lightbox.current.dialog.resize\(\)/) }
end
