class AlbumsController < ApplicationController

  # we want to ensure that the action has been authorized
  check_authorization
  load_and_authorize_resource :user
  load_and_authorize_resource :album

  respond_to :html, :xml

  # GET /albums
  # GET /albums.xml
  def index
    @albums = Album.all
    respond_with(@albums)
  end

#  # GET /albums/1
#  # GET /albums/1.xml
#  def show
#    @album = Album.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @album }
#    end
#  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new
    respond_with(@album)
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    respond_with(@album)
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])
    @album.user = current_user

    respond_to do |format|
      if @album.save
        format.any(:html,:js) { redirect_to(album_photos_path(@album), :notice => 'Album was successfully created.') }
        format.xml  { render :xml => @album, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
        format.js   { render :partial => "shared/update_lightbox_with_errors_for", :locals => { :model => @album } }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to(@album, :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(user_albums_path(@album.user)) }
      format.xml  { head :ok }
    end
  end
end
