class AppAdminController < ApplicationController
  
  layout '_navigation'
  before_filter :view_authorize, :only => [:apps, :versions]
  before_filter :authorize, :only => [:deleteapp, :deleteversion, :edit_detail]

  def apps
    @apps = App.all
  end

  def deleteapp
    appId = params[:app_id]
    app = App.find_by_id(appId)
    if app
      flash[:notice] = app.bundle_id + ' deleted.'
      app.destroy
    else
      flash[:alert] = 'No app found with id: ' + appId
    end

    redirect_to '/admin/apps'
  end

  def versions
    appId = params[:app_id]
    @app = App.find_by_id(appId)
    if !@app
      flash[:notice] = 'All this app\'s versions have been deleted. App id: ' + appId
      redirect_to '/admin/apps'
      return
    end
    @versions = @app.app_versions.reverse
  end

  def deleteversion
    version_id = params[:version_id]
    app_version = AppVersion.find_by_id(version_id)
    if app_version
      app_id = app_version.app.id
      app_version.destroy
      redirect_to '/admin/apps/' + app_id.to_s + '/versions'
    end
  end

  def version_detail
    version_id = params[:version_id]
    @app_version = AppVersion.find_by_id(version_id)
    if !@app_version
      flash[:alert] = 'App version with id ' + version_id + ' not found.'
      redirect_to '/admin/apps'
      return
    end

    if (can? :manage, App)
      render 'edit_version'
    elsif (can? :read, App)
      render 'version_detail'
    end 
  end

  def edit_detail
    version_id = params[:version_id]
    @app_version = AppVersion.find_by_id(version_id)
    if !@app_version
      flash[:alert] = 'App version with id ' + version_id + ' not found.'
      redirect_to '/admin/apps'
      return
    end

    post_hash = params[:app_version]
    new_change_log = post_hash["change_log"] if post_hash
    if new_change_log
      @app_version.change_log = new_change_log
      @app_version.save

      notice_string = "Edit Saved."
      alert_string = nil
    end

    post_hash = params[:app_version]
    new_external_manifest_url = post_hash["external_manifest_url"] if post_hash
    if new_external_manifest_url
      @app_version.external_manifest_url = new_external_manifest_url
      @app_version.save

      notice_string = "Edit Saved."
      alert_string = nil
    end

    uploaded_dSYM_io = params[:dsym]
    if uploaded_dSYM_io
      if !dSYM_io_type_available?(uploaded_dSYM_io)
        notice_string = nil
        alert_string = "Please choose a zip file as dSYM"
      else 
        FileSystemHelper.rm_file @app_version.dsym_path if @app_version.dsym_path

        dsym_relative_storage_path = FileSystemHelper.storage_path(@app_version.app.bundle_id, @app_version.beta_version.to_s, "dSYM.zip")
        FileSystemHelper.save_io_to_file(uploaded_dSYM_io, dsym_relative_storage_path)
        @app_version.dsym_path = dsym_relative_storage_path
        @app_version.save
      end
    end

    render 'edit_version'
  end

  #############################################################################
  # private methods

  private 

  # check access permission
  def view_authorize
    if current_user == nil
      redirect_to '/users/sign_in'
    elsif !(can? :read, App)
      flash[:notice] = "You don't have permission to view apps"
      redirect_to '/'
      return
    end
  end

  def authorize
    if current_user == nil
      redirect_to '/users/sign_in'
    elsif !(can? :manage, App)
      flash[:notice] = "You don't have permission to manage apps"
      redirect_to '/admin'
      return
    end 
  end

  def dSYM_io_type_available?(io)
    if io == nil
      return false
    elsif io.content_type != "application/zip" || File.extname(io.original_filename).downcase != ".zip"
      return false
    end

    return true
  end
end
