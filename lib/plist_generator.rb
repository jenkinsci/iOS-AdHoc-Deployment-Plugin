#Jesly Varghese 2012

#Part of OTA-Builder and Uploader Plugin For iOS Project

#Manifest Module
#Generate the manifest file for OTA

require 'rubygems'
require 'plist'

#This module requires intense refactoring, like moving the plist tempalate to a seprate file.

module Manifest

  def self.create(ipa_url,image_url,bundle_identifier,bundle_version,title,build_path)

    manifest = Plist::parse_xml '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>items</key>
  <array>
    <dict>
      <key>assets</key>
      <array>
        <dict>
          <key>kind</key>
          <string>software-package</string>
          <key>url</key>
          <string>&lt;http link for ipa file&gt;</string>
        </dict>
        <dict>
          <key>kind</key>
          <string>display-image</string>
          <key>needs-shine</key>
          <true/>
          <key>url</key>
          <string>&lt;http link for image file&gt;</string>
        </dict>
      </array>
      <key>metadata</key>
      <dict>
        <key>bundle-identifier</key>
        <string>&lt;bundle identifier of the app&gt;</string>
        <key>bundle-version</key>
        <string>&lt;bundle version ex 1.0&gt;</string>
        <key>kind</key>
        <string>software</string>
        <key>title</key>
        <string>&lt;Application title ex : Sales Catalog&gt;</string>
      </dict>
    </dict>
  </array>
</dict>
</plist>
'
    puts manifest
    return nil if manifest.nil?
    
    manifest['items'][0]['assets'][0]['url'] = ipa_url
    manifest['items'][0]['assets'][1]['url'] = image_url
    manifest['items'][0]['metadata']['bundle-identifier'] = bundle_identifier
    manifest['items'][0]['metadata']['bundle-version'] = bundle_version
    manifest['items'][0]['metadata']['title'] = title
    
    underscored_title = title.gsub /\s/ , '_'
    underscored_version = bundle_version.gsub /\./, '_'
    manifest_filename = "#{underscored_title}_#{underscored_version}.plist"
    
    manifest.save_plist "#{build_path}/#{manifest_filename}"
    return "#{build_path}/#{manifest_filename}"
  end
end
