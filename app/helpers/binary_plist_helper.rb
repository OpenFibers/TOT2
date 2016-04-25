module BinaryPlistHelper
	require 'cfpropertylist'

	#Class Methods
	class << self 
		def hash_from_plist_file(plist_file_path)
			if !plist_file_path
				return nil
			end

			plist = CFPropertyList::List.new(:file => plist_file_path)
	  		data = CFPropertyList.native_types(plist.value)
	  		return data
		end

		# get icon's zip path from parsed_plist_hash and zip_app_path
		# params: parsed_plist_hash : returned data from `hash_from_plist_file`
		# first find parsed_plist_hash["CFBundleIconFiles"].last
		# then find parsed_plist_hash["CFBundleIcons"]["CFBundlePrimaryIcon"]["CFBundleIconFiles"].last
		# then find parsed_plist_hash["CFBundleIconFile"]
		def get_icon_file_name(parsed_plist_hash)
			return nil if (!parsed_plist_hash || !parsed_plist_hash.respond_to?(:has_value?))

			# first find parsed_plist_hash["CFBundleIconFiles"].last
			icon_array = parsed_plist_hash["CFBundleIconFiles"]
			if icon_array && icon_array.length != 0
				return icon_array.last
			end

			# then find parsed_plist_hash["CFBundleIcons"]["CFBundlePrimaryIcon"]["CFBundleIconFiles"].lastObject
			bundle_icons = parsed_plist_hash["CFBundleIcons"]
			if bundle_icons && bundle_icons.length != 0
				primary_icon = bundle_icons["CFBundlePrimaryIcon"]
				if primary_icon && primary_icon.length != 0
					icon_array = primary_icon["CFBundleIconFiles"]
					if icon_array && icon_array.length != 0
						return icon_array.last + "@2x.png"
					end
				end
			end

			# else return "CFBundleIconFile"
			return parsed_plist_hash["CFBundleIconFile"]
		end

		# get iTunesArtwork
		def get_itunes_artwork_file_name(parsed_plist_hash)
			return 'iTunesArtwork'
		end

		# get version string from hash
		def get_version_string(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleVersion"]
		end

		# get short version string from hash
		def get_short_version_string(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleShortVersionString"]
		end

		# get bundle id from hash
		def get_bundle_id(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleIdentifier"]
		end

		# get display name from hash
		def get_display_name(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleDisplayName"] || parsed_plist_hash["CFBundleName"]
		end
	end
end
