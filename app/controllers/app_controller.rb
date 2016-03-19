class AppController < ApplicationController

  require 'manifest_helper'

  helper_method :get_encoded_manifest_url
  layout :resolve_layout
  before_filter :check_user_agent, :only => [:applist, :version_detail, :more_version]

  def applist
    @applist = App.all
    @back_uri = nil
    @navigation_title = 'Install Apps'
  end

  def version_detail
    version_id = params[:version_id]
    @back_uri = params[:back_uri] || '/'
    if version_id == nil
      redirect_to '/'
    end
    @app_version = AppVersion.find_by_id(version_id)
    if !@app_version
      @navigation_title = 'Version Not Found'
    else
      @navigation_title = 'Install ' + @app_version.app_name
    end
  end

  def more_version
    app_id = params[:app_id]
    @back_uri = params[:back_uri] || '/'
    if app_id == nil
      redirect_to '/'
    end
    @app = App.find_by_id(app_id)
    if !@app
      @navigation_title = 'App Not Found'
    else
      @versions = @app.app_versions.reverse
      if @versions.empty?
        @navigation_title = 'No Version Found'
      else
        @navigation_title = @app.bundle_id    
      end
    end
  end

  def get_manifest
    version_id = params[:version_id]
    if version_id == nil
      send_data(nil)
    end
    app_version = AppVersion.find_by_id(version_id)
    if app_version
      host_url = url_for(request.scheme + "://" + request.host_with_port + '/')
      manifest_data = ManifestHelper.gen_manifest(host_url, app_version)
      send_data(manifest_data, :filename=>'manifest.plist')
    end
  end

  def get_encoded_manifest_url(app_version)
    if app_version
      host_url = url_for(request.scheme + "://" + request.host_with_port + '/')
      manifest_url = ManifestHelper.get_manifest_url(host_url, app_version)
      encoded_url = URI.encode_www_form_component(manifest_url)
    end
  end

  private
  def from_iphone?
    iphone_text_location = request.user_agent =~ /iPhone|iPad/
    return iphone_text_location != nil
  end

  def check_user_agent
    if !from_iphone?
      render 'pc'
    end
  end

  def resolve_layout
    case from_iphone?
    when true
      "_distribution"
    else
      "_empty"
    end
  end
end
