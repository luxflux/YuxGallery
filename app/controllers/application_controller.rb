class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :create_objects

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

    def create_objects
      @user = User.find(params[:user_id]) if params[:user_id]
      @album = Album.find(params[:album_id]) if params[:album_id]

      case
        when params[:user_id] && params[:album_id] && params[:id]
          @photo = Photo.find(params[:id])
  
        when params[:user_id] && params[:id]
          @album = Album.find(params[:id])

        when params[:id]
          @user = User.find(params[:id])
      end
    end
end
