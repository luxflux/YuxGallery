# rightjs wants html-ul-list rendered

Mime::Type.register("application/rightjs_ac", :rightjs_ac)

ActionController::Renderers.add(:rightjs_ac) do |js, options|
  render = "<ul>"
  js.each do |model|
    render += "<li>#{model}</li>"
  end
  render += "</ul>"

  self.content_type = Mime::HTML
  self.response_body = render
end

