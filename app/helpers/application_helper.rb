module ApplicationHelper

  def yux_in_place_edit_js_call(element, url, field_name)
    element = "'#{element}'" unless element == :this
    "$(#{element}).inEdit({url: '#{url}'#{if field_name then ",name: '#{field_name}'" end }})"
  end

  def yux_in_place_edit_generate_id
    "in-edit-#{SecureRandom.hex(10)}"
  end

  def yux_in_place_edit_text(url, *args)
    options = args.extract_options!
    
    check_user = options[:check_user]
    content = options[:content] || options[:model].send(options[:attribute])
    field_name = "#{options[:model].class.name.tableize.singularize}[#{options[:attribute]}]"

    if check_user.nil? || check_user == current_user
      id = yux_in_place_edit_generate_id
      span = content_tag :span, :id => id, :onclick => yux_in_place_edit_js_call(:this, url, field_name) do
        content.html_safe
      end
      span + link_to_function(image_tag("icons/page_edit.png"), yux_in_place_edit_js_call(id, url, field_name))
    else
      content
    end
  end

  def form_auth_token
    (protect_against_forgery?) ? form_authenticity_token : ''
  end

  def yux_gallery_path
    dl = " &raquo; ".html_safe
    
    path = link_to(t(".path.start"), root_url)
    
    if params[:user_id]
      path += dl + link_to(params[:user_id], user_path(params[:user_id]))
      if params[:album_id]
        path += dl + link_to(params[:album_id], user_album_path(params[:user_id], params[:album_id]))
        if params[:id]
          path += dl + link_to(Photo.find(params[:id]).name, user_album_photo_path(params[:user_id], params[:album_id], params[:id]))
        end
      else
        if params[:id]
          path += dl + link_to(params[:id], user_album_path(params[:user_id], params[:id]))
        end
      end
    else
      if params[:id]
        path += dl + link_to(params[:id], user_path(params[:id]))
      end
    end
    path
  end

end
