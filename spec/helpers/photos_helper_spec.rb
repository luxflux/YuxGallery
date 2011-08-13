require "spec_helper"

describe PhotosHelper do
 
  describe "update_elements_js" do
    it "renders javascript to update several elements with content taken from another element" do
      update_elements_js("testfield", [ "ele1", "ele2" ]).should
        eq("$('ele1').html($(testfield).html());$('ele2').html($(testfield).html());")
    end
  end

end
