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
    
    check_user = options[:check_user] || options[:model].user
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

  def yux_gallery_path_get_title(model)
    if model.title
      model.title
    else
      t("#{model.class.name.tableize}.new.title")
    end
  end

  def yux_gallery_path
    content_tag :ul, :class => :gallery_path do
      p =  content_tag(:li, link_to(t(".path.start"), root_url))
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@user),  [@user, :albums]))         if @user
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@album), [@user, @album, :photos])) if @album
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@photo), [@user, @album, @photo]))  if @photo
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@scan),  [@user, @album, @scan]))   if @scan
      p
    end
  end

  def yux_link_to_with_photo(image_url, destination_url, *args)
    options = args.extract_options!
    
    rel   = options[:rel]
    title = options[:title]
    
    link_to(image_tag(image_url) +  content_tag(:span, title), destination_url, :class => :with_photo, :rel => rel, :title => title)
  end

  def yux_show_a_photo_collection(collection, *args)
    options = args.extract_options!
  
    prefix = options[:prefix]
    postfix = options[:postfix]

    content = ""
    content_tag :ul, :class => :photo_collection do
      collection.each do |item|
        url = prefix ? [ prefix, item ] : item
        url = case
          when prefix && postfix
            [ prefix, item, postfix ]
          when prefix
            [ prefix, item ]
          when postfix
            [ item, postfix ]
          else
            item
        end
        item_photo = item.respond_to?(:random_photo) ? item.random_photo : item
        item_photo_url = item_photo.respond_to?(:photo) ? item_photo.photo.thumb.url : yux_default_photo 
        content += content_tag :li do
          yux_link_to_with_photo(item_photo_url, url, :title => item.title)
        end
      end
      content += content_tag(:div, nil, :class => :clear)
      content.html_safe
    end
  end

  def link_to_lightbox(name, href)
    link_to(name, href, :rel => :lightbox, :title => name)
  end

  def yux_default_photo
    "/images/rails.png"
  end

end
