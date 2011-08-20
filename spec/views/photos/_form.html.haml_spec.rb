require "spec_helper"

describe "photos/_form.html.haml" do
  before do
    @user = stub_model(User)
    @album = stub_model(Album, :user_id => @user.id)
    @photo = stub_model(Photo, :album_id => @album.id).as_new_record
    assign(:user, @user)
    assign(:album, @album)
    assign(:photo, @photo)
    render
  end
 
  subject do
    rendered
  end

  it { should have_selector("form#new_photo.new_photo") }
  it { should have_selector("div#error_explanation") }
  [ :name, :description, :shot_at, :photo ].each do |field|
    it { should have_selector("label[for=photo_#{field}]") }
    it { should have_selector("input#photo_#{field}") }
  end
  it { should have_selector("input#photo_photo_cache[type=hidden]") }
  it { should have_selector("div.actions input[type=submit]") }
end
