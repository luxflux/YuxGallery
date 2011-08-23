class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  # i18n localization
  alias_method :t_original, :t
  def t(*args)
    if args.first[0..1] == '..'
      args[0] = params[:controller].gsub('/','.') + args.first[1..-1]
    elsif args.first.first == '.'
      args[0] = params[:controller].gsub('/','.') + '.' + params[:action] + args.first
    end
    t_original(*args)
  end

  unless Rails.env.test?
    rescue_from CanCan::AccessDenied do |exception|
      logger.error("Access denied: #{exception.action} on #{exception.subject}")
      redirect_to root_url, :alert => exception.message
    end
  end

  private
    def layout
      request.xhr? ? false : "application"
    end

end
