require "spec_helper"

describe "albums/_form.html.haml" do
  before do
    @user = stub_model(User)
    @album = stub_model(Album, :user => @user).as_new_record
    assign(:user, @user)
    assign(:album, @album)
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("form#new_album.new_album") }
  it { should have_selector("div#error_explanation") }
  [ :name, :date_start, :date_end ].each do |field|
    it { should have_selector("label[for=album_#{field}]") }
    it { should have_selector("input#album_#{field}") }
  end
  it { should have_selector("textarea#album_description") }
  it { should have_selector("div.actions input[type=submit]") }
end
