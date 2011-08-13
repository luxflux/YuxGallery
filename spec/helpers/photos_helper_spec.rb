require "spec_helper"

describe ApplicationHelper do
 
  before do
    @user  = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @album = FactoryGirl.create(:album, :user_id => @user.id)
    @photo = FactoryGirl.create(:photo, :album_id => @album.id)
  end

  describe "update_elements_js" do
    it "renders javascript to update several elements with content taken from another element" do
      update_elements_js("testfield", [ "ele1", "ele2" ]).should
        eq("$('ele1').html($(testfield).html());$('ele2').html($(testfield).html());")
    end
  end

end
