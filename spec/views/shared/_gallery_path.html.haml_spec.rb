require "spec_helper"

describe "shared/_gallery_path.html.haml" do
  before do
    user = stub_model(User, :nickname => "Usernick")
    album = stub_model(Album, :title => "Albumtitle", :user => user)
    photo = stub_model(Photo, :title => "Phototitle", :album => album)
    scan = stub_model(Scan, :album => album)
    @prepared = {
      :user => user,
      :album => album,
      :photo => photo,
      :scan => scan
    }
  end
  
  context "with a user" do
    before do
      @user = @prepared[:user]
      render
    end

    subject do
      rendered
    end

    it { should match(/Start/) }
    it { should match(/#{@prepared[:user].nickname}/) }
    it { should_not match(/#{@prepared[:album].title}/) }
    it { should_not match(/#{@prepared[:photo].title}/) }
    it { should_not match(/#{@prepared[:scan].id}/) }
    it { should have_selector("li", :count => 2) }
  end

  context "with an album" do
    before do
      @album = @prepared[:album]
      render
    end

    subject do
      rendered
    end

    it { should match(/Start/) }
    it { should match(/#{@prepared[:user].nickname}/) }
    it { should match(/#{@prepared[:album].title}/) }
    it { should_not match(/#{@prepared[:photo].title}/) }
    it { should_not match(/#{@prepared[:scan].id}/) }
    it { should have_selector("li", :count => 3) }
  end
  
  context "with a photo" do
    before do
      @photo = @prepared[:photo]
      render
    end

    subject do
      rendered
    end

    it { should match(/Start/) }
    it { should match(/#{@prepared[:user].nickname}/) }
    it { should match(/#{@prepared[:album].title}/) }
    it { should match(/#{@prepared[:photo].title}/) }
    it { should_not match(/#{@prepared[:scan].id}/) }
    it { should have_selector("li", :count => 4) }
  end
  
  context "with a scan" do
    before do
      @scan = @prepared[:scan]
      render
    end

    subject do
      rendered
    end

    it { should match(/Start/) }
    it { should match(/#{@prepared[:user].nickname}/) }
    it { should match(/#{@prepared[:album].title}/) }
    it { should_not match(/#{@prepared[:photo].title}/) }
    it { should match(/#{@prepared[:scan].id}/) }
    it { should have_selector("li", :count => 4) }
  end
end
