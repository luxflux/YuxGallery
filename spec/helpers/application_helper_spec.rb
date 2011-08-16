require "spec_helper"

describe ApplicationHelper do
 
  before do
    @user  = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @photo = FactoryGirl.create(:photo, :album_id => @album.id)
  end

  let :current_user do
    @user
  end

  describe "yux_in_place_edit_text" do
    before do
      @url = user_album_photo_path(@photo.user, @photo.album, @photo)
    end

    context "with the user the photo belongs to" do
      it "should return javascript calls for the in-edit component" do
        yux_in_place_edit_text(@url, :model => @photo, :attribute => :name, :update_elements => [ @photo.name ]).should match(/inEdit/)
      end
    end
    context "with another user as the photo belongs to" do
      let :current_user do
        @user2
      end
      it "should just return the text" do
        yux_in_place_edit_text(@url, :model => @photo, :attribute => :name, :update_elements => [ @photo.name ]).should_not match(/inEdit/)
      end
    end
  end

  describe "form_auth_token" do
    let :form_authenticity_token do
      "123456abcdef"
    end
    context "if protection against forgery is needed" do
      let :protect_against_forgery? do
        true
      end
      it "returns the form authenticity token" do
        form_auth_token.should eq("123456abcdef")
      end
    end
    context "if protection against forgery isn't needed" do
      let :protect_against_forgery? do
        false
      end
      it "returns the form authenticity token" do
        form_auth_token.should eq("")
      end
    end
  end

  describe "yux_gallery_path" do
    let :t do
      "Start"
    end
    context "with a selected user" do
      before do
        @album = nil
        @photo = nil
      end
      subject do
        yux_gallery_path
      end
      it { should match(/Start/) }
      it { should match(/Testobject/) }
      it { should_not match(/Test Album/) }
      it { should_not match(/Photo/) }
    end
    context "with a selected user and an album" do
      before do
        @photo = nil
      end
      subject do
        yux_gallery_path
      end
      it { should match(/Start/) }
      it { should match(/Testobject/) }
      it { should match(/Test Album/) }
      it { should_not match(/Photo/) }
    end
    context "with a selected user, album and a photo" do
      subject do
        yux_gallery_path
      end
      it { should match(/Start/) }
      it { should match(/Testobject/) }
      it { should match(/Test Album/) }
      it { should match(/Photo/) }
    end
    context "with a selected user, album and a scan" do
      before do
        @photo = nil
        @scan = FactoryGirl.build(:scan, :album_id => @album.id)
        FileUtils.mkdir(@scan.fullpath)
        @scan.save
      end
      after do
        FileUtils.rm_rf(@scan.fullpath)
      end
      subject do
        yux_gallery_path
      end
      it { should match(/Start/) }
      it { should match(/Testobject/) }
      it { should match(/Test Album/) }
      it { should_not match(/Photo/) }
      it { should match(/Scan #1/) }
    end
  end

  describe "link_to_lightbox" do
    it "returns a link to the lightbox" do
      link_to_lightbox("test", users_path).should eq("<a href=\"/users\" rel=\"lightbox\" title=\"test\">test</a>")
    end
  end

  describe "show_a_lightbox" do
    it "returns javascript to open a lightbox" do
      show_a_lightbox("Test","Content Test").should eq("Lightbox.show('Content Test').setTitle('Test');")
    end
  end

  describe "display_error_messages" do
    it "renders the error messages and adds some javascript to display it" do
      @album.name = ''
      @album.date_start = Time.now
      @album.date_end = Time.now - 1.day
      @album.save
      display_error_messages(@album).should match(/<div.+error_explanation.+2 errors prohibited.+Name can't be blank.+Date end should be later.+javascript/)
    end
  end

  describe "update_lightbox" do
    context "with a title" do
      it "renders javascript to update the lightbox including the title" do
        update_lightbox("Test Title") do
          'This Is A Test;'
        end.should eq("This Is A Test;Lightbox.current.dialog.resize();Lightbox.current.dialog.setTitle('Test Title')")
      end
    end
    context "without a title" do
      it "renders javascript to update the lightbox without the setTitle part" do
        update_lightbox do
          'This is a test;'
        end.should eq("This is a test;Lightbox.current.dialog.resize();")
      end
    end
  end

  describe "label_with_tooltip" do
    context "with a given tooltip" do
      it "renders a label for a field with the given tooltip" do
        form_for(@user) do |f|
          label_with_tooltip(f, :nickname, "ToolTipTest").should
            eq("<label data-tooltip=\"true\" for=\"user_nickname\" title=\"ToolTipTest\">Nickname</label><img alt=\"Help\" data-tooltip=\"true\" src=\"/images/icons/help.png\" title=\"ToolTipTest\" />")
        end
      end
    end

    context "without a given tooltip" do
      it "renders a label for a field without the given tooltip" do
        form_for([@user, @album]) do |f|
          result = label_with_tooltip(f, :date_start)
          result.should eq("<label data-tooltip=\"true\" for=\"album_date_start\" title=\"Date when the first photo of the album has been taken, if left empty will be filled in when photos are added\">Date start</label><img alt=\"Help\" data-tooltip=\"true\" src=\"/images/icons/help.png\" title=\"Date when the first photo of the album has been taken, if left empty will be filled in when photos are added\" />")
        end
      end
    end
  end

end
