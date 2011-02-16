class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  def index
    @photos = Album.find(params[:album_id]).photos

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])
    @photo.album = current_user.albums.find(params[:album_id])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to([current_user, @photo.album, @photo], :notice => 'Photo was successfully created.') }
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
    @photo = current_user.albums.find(params[:album_id]).photos.find(params[:id])
  
    if request.xhr?
      key, value = params[:photo].first
    end

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to([current_user, @photo.album, @photo], :notice => 'Photo was successfully updated.') }
        format.xml  { head :ok }
        format.js   { render :js => @photo.send(key) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
        format.js   { render :js => @photo.send(key) }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end
end