require "spec_helper"

describe "albums/edit.html.haml" do
  before do
    stub_template "_form" => "rendered form"
    render
  end

  it "renders the form partial" do
    rendered.should eq("rendered form\n")
  end
end
