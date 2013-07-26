class UploadController < ApplicationController

	require 'zip/zip'
	require 'file_system_helper'

	layout '_navigation'
	before_filter :authorize, :only => [:upload]

	#############################################################################
	# actions

	def upload
		# save files if ipa POSTed
		if request.request_method == 'POST' # an upload performed with POST method

			notice_string = "Upload successed."
			alert_string = nil;

			#save ipa to disk
			uploaded_ipa_io = params[:ipa] # uploaded ipa file handle
			if uploaded_ipa_io != nil # if ipa exist, save it to local storage
				uploaded_ipa_name = Rails.root.join('public', 'uploads', uploaded_ipa_io.original_filename)
				FileSystemHelper.save_io_to_file(uploaded_ipa_io, uploaded_ipa_name)

				Zip::ZipFile.open(uploaded_ipa_name) do |zipfile|
				end

			else #if ipa doesn't exist, make an error to user
				notice_string = nil;
				alert_string = "IPA file doesn't exist."
			end

			#save dSYM to disk, if alert_string == nil, which indicates ipa upload successed
			if alert_string == nil			
				uploaded_dsym_io = params[:dsym] #uploaded dSYM file handle
				if uploaded_dsym_io != nil #if dSYM exist, save it to local storage
					uploaded_dsym_name = Rails.root.join('public', 'uploads', uploaded_dsym_io.original_filename)
					FileSystemHelper.save_io_to_file(uploaded_dsym_io, uploaded_dsym_name)
				else #if dSYM doesn't exist, make an warning to user
					notice_string = "IPA upload successed, but it's suggested that to upload a dSYM. You can upload it later in \"Apps\" tab."
					alert_string = nil;
				end
			end

		    flash[:notice] = notice_string
		    flash[:alert] = alert_string

		    if alert_string == nil # upload successed, redirect to apps page
		    	redirect_to '/admin'
		    end
		end
	end

	#############################################################################
	# private methods

	private	

	# check access permission
	def authorize
		if current_user == nil || !(can? :manage, @app)
			flash[:notice] = "You don't have permission to access upload page."
			redirect_to '/admin'
			return
		end 
	end

end
