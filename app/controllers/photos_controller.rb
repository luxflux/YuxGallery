class PhotosController < ApplicationController

  # we want to ensure that the action has been authorized
  check_authorization
  load_and_authorize_resource :user
  load_and_authorize_resource :album, :through => :user, :shallow => true
  load_and_authorize_resource :photo, :through => :album, :shallow => true

  respond_to :xml, :html

  # GET /photos
  # GET /photos.xml
  def index
    @photos = Album.find(params[:album_id]).photos
    respond_with(@photos)
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    respond_with(@photo)
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    respond_with(@photo)
  end

  # GET /photos/1/edit
  def edit
    respond_with(@photo)
  end

  # POST /photos
  # POST /photos.xml
  def create
    #@photo = Photo.new(params[:photo])
    #@photo.album = current_user.albums.find(params[:album_id])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to(@photo, :notice => 'Photo was successfully created.') }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to(@photo, :notice => 'Photo was successfully updated.') }
        format.xml  { head :ok }
        format.js   { render :js => @photo.send(params[:photo].first.first.to_sym) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
        format.js   { render :js => @photo.send(params[:photo].first.first.to_sym) }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to([@album, :photos]) }
      format.xml  { head :ok }
    end
  end
end
