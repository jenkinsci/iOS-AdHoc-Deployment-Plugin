require 'rubygems'
require 'require_relative'

require_relative '../lib/plist_generator.rb'
require_relative '../lib/ftp_upload.rb'

class PathignoreWrapper<Jenkins::Tasks::Publisher
  display_name 'Upload Build and Mail OTA link'
  
  attr_accessor :ipa_path
              , :icon_path
              , :bundle_identifier
              , :bundle_version
              , :title
              , :ftp_ota_dir
              , :ftp_hostname
              , :ftp_username
              , :ftp_password
  
  def initialize
    @ipa_path = attrs['ipa_path']
    @icon_path = attrs['icon_path']
    @bundle_identifier = attrs['bundle_identifier']
    @bundle_version = attrs['bundle_version']
    @title = attrs['title']
    @ftp_ota_dir = attrs['ftp_ota_dir']
    @ftp_hostname = attrs['ftp_hostname']
    @ftp_username = attrs['ftp_username']
    @ftp_password = attrs['ftp_password']
  end
  
  def needsToRunAfterFinalized
    return true
  end
  
  def perform(build,launcher,listner)
    BuildContext.instance.set(build,launcer,listner) do
      workspace_path = build.getWorkspace #get the workspace path
      ipa_file = "#{workspace_path}/#{@ipa_path}"
      icon_file = "#{workspace_path}/#{@icon_path}"
      ipa_filename = File.basename ipa_file, '.*'
      icon_filename = File.basename icon_file, '.*'
      ipa_url = "#{@ftp_hostname}/#{@ftp_ota_dir}/#{ipa_filename}"
      icon_url = "#{@ftp_hostname}/#{@ftp_ota_dir}/#{icon_filename}"
      manifest_file = Manifest::create ipa_url,icon_url,@bundle_identifier,@bundle_version,@title,'ManifestTemplate.plist',File.dirname(ipa_file)
      
      FTP::upload @ftp_hostname, @ftp_username, @ftp_password, @ftp_ota_dir, [ipa_file,icon_file,manifest_file] 
    end
  end
  
end
