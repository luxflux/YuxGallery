class ScansController < ApplicationController

  before_filter :init_scan

  respond_to :html, :xml, :json

  # GET /scans
  # GET /scans.xml
  def index
    @scans = Scan.all

    respond_with(@scans)
  end

  # GET /scans/1
  # GET /scans/1.xml
  def show
    @scan = Scan.find(params[:id])
    #reply = {
    #  "state" => "uploading",
    #  "received" => "50",
    #  "size" => "100",
    #  "speed" => "0",
    #  "started_at" => @scan.created_at.to_i,
    #  "uuid" => @scan.id
    #}

    respond_with(@scan.status)
  end

  # GET /scans/new
  # GET /scans/new.xml
  def new
    @scan = @album.scans.new
    respond_with(@scan)
  end

  # GET /scans/1/edit
#  def edit
#    @scan = Scan.find(params[:id])
#    respond_with(@scan)
#  end

  # POST /scans
  # POST /scans.xml
  def create
    @scan = @album.scans.new(params[:scan])

    respond_to do |format|
      if @scan.save
        format.html { redirect_to([ @user, @album, @scan ], :notice => 'Scan was successfully created.') }
        format.xml  { render :xml => @scan, :status => :created, :location => [ @user, @album, @scan ] }
        format.js   { render :js => "Lightbox.load('#{user_album_scan_path(@user, @album, @scan)}');" }
      else
        @scan.directory = @scan.directory.gsub(%r{#{Regexp.escape(current_user.sftp_folder)}}, '')
        format.html { render :action => "new" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
        format.js   { render :partial => "layouts/update_lightbox_with_errors_for", :local => { :model => @scan } }
      end
    end
  end

  # PUT /scans/1
  # PUT /scans/1.xml
#  def update
#    @scan = Scan.find(params[:id])
#
#    respond_to do |format|
#      if @scan.update_attributes(params[:scan])
#        format.html { redirect_to(@scan, :notice => 'Scan was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /scans/1
  # DELETE /scans/1.xml
  def destroy
    @scan = Scan.find(params[:id])
    @scan.destroy

    respond_to do |format|
      format.any(:html, :js) { redirect_to([@user, @album, :scans]) }
      format.xml             { head :ok }
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
