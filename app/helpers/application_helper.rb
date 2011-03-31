module ApplicationHelper

  def yux_in_place_edit_js_call(element, url, field_name, update_elements = nil)
    element = "'#{element}'"
    "$(#{element}).inEdit({url: '#{url}'#{if field_name then ",name: '#{field_name}'" end }}).on('update', function(ele) {
      #{update_elements_js(element, update_elements)}
    });"
  end

  # could be overwritten in the specific controller helpers!
  def update_elements_js(src_field, update_elements)
    r = []
    update_elements.each do |ele|
      r << "$('#{ele}').html($(#{src_field}).html());"
    end
    r.join
  end

  def yux_in_place_edit_generate_id
    "in-edit-#{SecureRandom.hex(10)}"
  end

  def yux_in_place_edit_text(url, *args)
    options = args.extract_options!
    
    check_user = options[:check_user] || options[:model].user
    content = options[:content] || options[:model].send(options[:attribute])
    field_name = "#{options[:model].class.name.tableize.singularize}[#{options[:attribute]}]"
    update_elements = options[:update_elements] || []

    if check_user.nil? || check_user == current_user
      id = yux_in_place_edit_generate_id
      js_call = yux_in_place_edit_js_call(id, url, field_name, update_elements)
      span = content_tag :span, :id => id, :onclick => js_call do
        content.html_safe
      end
      span + link_to_function(image_tag("icons/page_edit.png"), js_call)
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
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@user),  [@user, :albums]))         if @user && !@user.new_record?
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@album), [@user, @album, :photos])) if @album && !@album.new_record?
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@photo), [@user, @album, @photo]))  if @photo
      p += content_tag(:li, link_to(yux_gallery_path_get_title(@scan),  [@user, @album, @scan]))   if @scan
      p
    end
  end

  def yux_link_to_with_photo(image_url, destination_url, *args)
    options = args.extract_options!
    
    rel   = options[:rel]
    title = options[:title]
    id    = options[:id]
    
    link_to(image_tag(image_url) + content_tag(:span, title, :id => title), destination_url, :class => :with_photo, :rel => rel, :title => title, :id => id)
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

  def show_a_lightbox(title, content)
    "Lightbox.show('#{escape_javascript(content)}').setTitle('#{title}');".html_safe
  end

  def display_error_messages(model)
    content = ""
    expl = content_tag :div, :id => "error_explanation" do
      if model.errors.any?
        content += content_tag(:h2, t("errors.prohibited_from_saved", :count => model.errors.count, :model => model.class.name))
        content += content_tag(:ul) do
          list = ""
          model.errors.full_messages.each do |msg|
            list += content_tag(:li, msg)
          end
          list.html_safe
        end
      end
      content.html_safe
    end
    expl += javascript_tag { "$('error_explanation').show();" } unless content.empty?
    expl
  end

  def update_lightbox(title = nil)
    yield
    content = "Lightbox.current.dialog.resize();"
    content += "Lightbox.current.dialog.setTitle('#{title}')" if title
    content
  end

  def update_lightboxes_with_errors_for(model)
    update_page do |page|
      update_lightbox do
        "$('error_explanation').replace(#{escape_javascript(display_error_messages(model))});
        $('error_explanation').show();"
      end
    end
  end

  def yux_default_photo
    "/images/rails.png"
  end

  def label_with_tooltip(f, name, tooltip = false)
    tooltip = t(".tooltip.#{name}") unless tooltip
    f.label(name, :title => tooltip, :"data-tooltip" => true) + icon_tag(:help, :title => tooltip, :"data-tooltip" => true)
  end

  def icon_tag(icon, *args)
    options = args.extract_options!
    image_tag("icons/#{icon}.png", options)
  end

end
