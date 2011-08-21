class UsersController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :xml, :rightjs_ac

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

#  # GET /users/1
#  # GET /users/1.xml
#  def show
#    @user = User.find(params[:id])
#    @albums = @user.albums
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @user }
#    end
#  end

# not used with devise
#  # GET /users/new
#  # GET /users/new.xml
#  def new
#    @user = User.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @user }
#    end
#  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

# not used with devise
#  # POST /users
#  # POST /users.xml
#  def create
#    @user = User.new(params[:user])
#
#    respond_to do |format|
#      if @user.save
#        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
#        format.xml  { render :xml => @user, :status => :created, :location => @user }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      case
        when @user != current_user
          format.html { redirect_to(root_url, :alert => t(".disallowed")) }
          format.xml  { head :method_not_allowed }
          format.js   { render :js => "raf_update_flash('alert', '#{t(".disallowed")}'); Lightbox.hide()" }
        when @user.update_attributes(params[:user])
          format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
          format.js   { render :js => "raf_update_flash('notice','#{t(".ok")}'); Lightbox.hide()" }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
          format.js   { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # GET /users/:id/folders
  def folders
    @folders = User.find(params[:id]).glob_sftp_folders(params[:search])
    respond_with(@folders) do |format|
      format.rightjs_ac { render :rightjs_ac => @folders }
    end
  end

end
