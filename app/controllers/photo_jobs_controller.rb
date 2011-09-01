class PhotoJobsController < ApplicationController
  # GET /photo_jobs
  # GET /photo_jobs.json
  def index
    @photo_jobs = PhotoJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @photo_jobs }
    end
  end

  # GET /photo_jobs/1
  # GET /photo_jobs/1.json
  def show
    @photo_job = PhotoJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @photo_job }
    end
  end

  # GET /photo_jobs/new
  # GET /photo_jobs/new.json
  def new
    @photo_job = PhotoJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @photo_job }
    end
  end

  # GET /photo_jobs/1/edit
  def edit
    @photo_job = PhotoJob.find(params[:id])
  end

  # POST /photo_jobs
  # POST /photo_jobs.json
  def create
    @photo_job = PhotoJob.new(params[:photo_job])

    respond_to do |format|
      if @photo_job.save
        format.html { redirect_to @photo_job, :notice => 'Photo job was successfully created.' }
        format.json { render :json => @photo_job, :status => :created, :location => @photo_job }
      else
        format.html { render :action => "new" }
        format.json { render :json => @photo_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photo_jobs/1
  # PUT /photo_jobs/1.json
  def update
    @photo_job = PhotoJob.find(params[:id])

    respond_to do |format|
      if @photo_job.update_attributes(params[:photo_job])
        format.html { redirect_to @photo_job, :notice => 'Photo job was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @photo_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_jobs/1
  # DELETE /photo_jobs/1.json
  def destroy
    @photo_job = PhotoJob.find(params[:id])
    @photo_job.destroy

    respond_to do |format|
      format.html { redirect_to photo_jobs_url }
      format.json { head :ok }
    end
  end
end
