module ManifestHelper
  class << self 

    def gen_manifest(host_url, app_version)
      ipa_download_link = host_url + app_version.ipa_download_url
      bundle_id = app_version.app.bundle_id
      version_string = app_version.version + ' (' + app_version.short_version + ')'
      app_name = app_version.app_name

      text = ''
      text += '<?xml version="1.0" encoding="UTF-8"?>'
      text += '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
      text += '<plist version="1.0">'
      text += '  <dict>'
      text += '    <key>items</key>'
      text += '    <array>'
      text += '      <dict>'
      text += '        <key>assets</key>'
      text += '        <array>'
      text += '          <dict>'
      text += '            <key>kind</key>'
      text += '            <string>software-package</string>'
      text += '            <key>url</key>'
      text += '            <string>' + ipa_download_link + '</string>' # download link
      text += '          </dict>'
      text += '        </array>'
      text += '        <key>metadata</key>'
      text += '        <dict>'
      text += '          <key>bundle-identifier</key>'
      text += '          <string>' + bundle_id + '</string>' # bundle id
      text += '          <key>bundle-version</key>'
      text += '          <string>' + version_string + '</string>'# version
      text += '          <key>kind</key>'
      text += '          <string>software</string>'
      text += '          <key>title</key>'
      text += '          <string>' + app_name + '</string>' # app name
      text += '        </dict>'
      text += '      </dict>'
      text += '    </array>'
      text += '  </dict>'
      text += '</plist>'
      return text
    end

    def get_manifest_url(host_url, app_version)
      manifest_url = ""
      if app_version.external_manifest_url && app_version.external_manifest_url.length != 0
        manifest_url = app_version.external_manifest_url
      else
        manifest_url = host_url + 'getmanifest/' + app_version.id.to_s
      end
      return manifest_url
    end
  end
end
