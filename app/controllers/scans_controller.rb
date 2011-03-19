class ScansController < ApplicationController

  before_filter :init_scan

  # GET /scans
  # GET /scans.xml
  def index
    @scans = Scan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end

  # GET /scans/1
  # GET /scans/1.xml
  def show
    @scan = @album.scans.find(params[:id]) if @album.user == current_user

    #reply = {
    #  "state" => "uploading",
    #  "received" => "50",
    #  "size" => "100",
    #  "speed" => "0",
    #  "started_at" => @scan.created_at.to_i,
    #  "uuid" => @scan.id
    #}

    respond_to do |format|
      format.html do
      end
      format.js   { render :action => :show }
      format.xml  { render :xml => @scan.status }
      format.json { render :json => @scan.status }
    end
  end

  # GET /scans/new
  # GET /scans/new.xml
  def new
    @scan = @album.scans.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scan }
    end
  end

  # GET /scans/1/edit
  def edit
    @scan = Scan.find(params[:id])
  end

  # POST /scans
  # POST /scans.xml
  def create
    if @album.user == current_user
      @scan = @album.scans.new(params[:scan])
#      @scan.directory = File.join(current_user.sftp_folder, params[:scan][:directory])
    end

    respond_to do |format|
      if @scan.save
        format.html { redirect_to([ @user, @album, @scan ], :notice => 'Scan was successfully created.') }
        format.xml  { render :xml => @scan, :status => :created, :location => @scan }
        format.js   { render :js => "Lightbox.load('#{user_album_scan_path(@user, @album, @scan)}');" }
      else
        @scan.directory = @scan.directory.gsub(%r{#{Regexp.escape(current_user.sftp_folder)}}, '')
        format.html { render :action => "new" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
        format.js do
        end
      end
    end
  end

  # PUT /scans/1
  # PUT /scans/1.xml
  def update
    @scan = Scan.find(params[:id])

    respond_to do |format|
      if @scan.update_attributes(params[:scan])
        format.html { redirect_to(@scan, :notice => 'Scan was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scans/1
  # DELETE /scans/1.xml
  def destroy
    @scan = Scan.find(params[:id])
    @scan.destroy

    respond_to do |format|
      format.html { redirect_to(scans_url) }
      format.xml  { head :ok }
    end
  end

  # GET /scans/folders
  def folders
    @list = current_user.glob_sftp_folders(params[:search])
    render :rightjs_ac => @list
  end

  private
    def init_scan
      @scan = Scan.find(params[:id]) if params[:id]
    end
end
