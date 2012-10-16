require 'rubygems'
require 'plist'

module Manifest

  def create(ipa_url,image_url,bundle_identifier,bundle_version,title,template_name,build_path)
    manifest = Plist::parse_xml '../resources/#{template_name}'
    
    manifest['items'][0]['assets'][0]['url'] = ipa_url
    manifest['items'][0]['assets'][1]['url'] = image_url
    manifest['items'][0]['metadata']['bundle-identifier'] = bundle_identifier
    manifest['items'][0]['metadata']['bundle-version'] = bundle_version
    manifest['items'][0]['metadata']['title'] = title
    
    underscored_title = title.gsub /\s/ , '_'
    underscored_version = bundle_version.gsub /\./, '_'
    manifest_filename = "#{underscored_title}_#{underscored_version}.plist"
    
    manifest.save "#{build_path}/#{manifest_filename}"
    
    return manifest_filename
  end
end
