require "spec_helper"

describe "scans/create.js.haml" do

  let(:scan) do
    FactoryGirl.build(:scan)
  end

  before do
    assign(:scan, scan)
    render
  end
 
  subject do
    puts rendered
    rendered
  end

  it { should match(/\$\('error_explanation'\)\.replace/) }
  it { should match(/\$\('error_explanation'\)\.show\(\)/) }
  it { should match(/Lightbox.current.dialog.resize\(\)\;/) }
end
