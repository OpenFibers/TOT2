module FileSystemHelper

	require 'zip/zip'

	#Class Methods
	class << self 
		# helper method, generate storage dir for icon, iTunesArtwork, ipa and dSYM
		def storage_path(bundle_id, beta_version = '', file_name = '')
			if beta_version
				ret_path = 'public/uploads/storage/' + bundle_id + '/' + beta_version + '/' + file_name
			else
				ret_path = 'public/uploads/storage/' + bundle_id + '/'
			end
			return ret_path
		end

		# helper method, create dir if it doesn't exist
		def make_dir_at_path(string)
			dir = File.dirname(string)

			unless File.directory?(dir)
				FileUtils.mkdir_p(dir)
			end
		end

		# helper method, move file
		def mv_file(source, destination)
			FileUtils.rm(destination) if File.exist?(destination)
			FileSystemHelper.make_dir_at_path(destination)
			File.rename(source, destination)
		end

		# helper method, remove file
		def rm_file(file_path)
			return if !file_path
			FileUtils.rm_rf(file_path) if File.exist?(file_path)
		end

		#helper method, save io to file
		def save_io_to_file(io, file_path)

			if io == nil || file_path == nil
				return
			end

			make_dir_at_path(file_path)

			File.open(file_path, 'wb+') do |file|
				file.write(io.read)
			end
		end

		# find zip/Payload/*.app/ from zip file
		def find_app_path_from_zip_file(zip_file_path)
			Zip::ZipFile.open(zip_file_path) do |zipfile|
			zipfile.each { |zipentry|
				matched_name = /Payload\/\w+\.app\//.match(zipentry.name)
				matched_name = /Payload\/\b([\w-]+\s?[\w-]*)+\b\.app\//.match(zipentry.name)	
				return matched_name.to_s if matched_name
			}
			end
		end

		# test method
		# zip entry list
		def zip_entry_list(zip_file_path)
			entry_list = []
			Zip::ZipFile.open(zip_file_path) do |zipfile|
			zipfile.each { |zipentry|
				zip_path = zipentry.name # path for file to unzip in zip file
				entry_list << zip_path
			}
			end
			return entry_list
		end

		# helper method, zip a zipfile's subfile to destination path
		# params:
		# 	zip_file_path : file to unzip
		# 	unzip_path_hash : a hash contains unzip info.
		# 		e.g. : unzip zip/a to /tmp/a and unzip zip/b to /tmp/b, pass {"zip/a":"/tmp/a", "zip/b":"tmp/b"}
		def zip_file_to_destination(zip_file_path, unzip_path_hash)
			Zip::ZipFile.open(zip_file_path) do |zipfile|
			zipfile.each { |zipentry|
				zip_path = zipentry.name # path for file to unzip in zip file
				unzip_path = unzip_path_hash[zip_path] # destination path for file to unzip
				if unzip_path # extract file if needed
					FileUtils.rm(unzip_path) if File.exist?(unzip_path) # rm previous file
					make_dir_at_path(unzip_path) # create dir if needed
					zipfile.extract(zipentry, unzip_path) # extract file
					next
				end
			}
			end
		end
	end

end
