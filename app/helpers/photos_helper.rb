module PhotosHelper

  def update_elements_js(src_field, update_elements)
    r = []
    update_elements.each do |ele|
      r << "content = $(#{src_field}).html();"
      r << "$('#{ele}').html(content);"
      r << "$('#{ele}').parent().set('title', content);"
    end 
    r.join
  end

end
