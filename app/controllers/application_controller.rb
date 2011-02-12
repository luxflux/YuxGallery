class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  # i18n localization
  alias_method :t_original, :t
  def t(*args)
    if args.first[0..1] == '..'
      args[0] = params[:controller].gsub('/','.')+args.first[1..-1]
    elsif args.first.first == '.' 
      args[0] = params[:controller].gsub('/','.')+'.'+params[:action]+args.first    end
    t_original(*args)
  end 

  private
    def layout
      request.xhr? ? false : "application"
    end


end
