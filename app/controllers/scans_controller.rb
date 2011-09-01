class ScansController < ApplicationController

  # we want to ensure that the action has been authorized
  check_authorization
  load_and_authorize_resource :user
  load_and_authorize_resource :album, :through => :user, :shallow => true
  load_and_authorize_resource :scan, :through => :album, :shallow => true

  respond_to :html, :xml, :json

  # GET /scans
  # GET /scans.xml
  def index
    respond_with(@scans)
  end

  # GET /scans/1
  # GET /scans/1.xml
  def show
    respond_with(@scan.status)
  end

  # GET /scans/new
  # GET /scans/new.xml
  def new
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
    respond_to do |format|
      if @scan.save
        format.html { redirect_to(@scan, :notice => 'Scan was successfully created.') }
        format.xml  { render :xml => @scan, :status => :created, :location => @scan }
        format.js   { render :js => "Lightbox.load('#{scan_path(@scan)}');" }
      else
        @scan.directory = @scan.directory.gsub(%r{#{Regexp.escape(current_user.sftp_folder)}}, '')
        format.html { render :action => "new" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
        format.js   { render :partial => "shared/update_lightbox_with_errors_for", :locals => { :model => @scan } }
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
    @scan.destroy

    respond_to do |format|
      format.any(:html, :js) { redirect_to([@album, :scans]) }
      format.xml             { head :ok }
    end
  end
end
