require 'rubygems'
require 'require_relative'
require 'pony'

require_relative '../lib/plist_generator.rb'
require_relative '../lib/ftp_upload.rb'


class OtabuilderWrapper<Jenkins::Tasks::Publisher
  include Jenkins::Model::DescribableNative
  
  display_name 'Upload Build and Mail OTA link'
  
  attr_accessor :ipa_path
  attr_accessor :icon_path
  attr_accessor :bundle_identifier
  attr_accessor :bundle_version
  attr_accessor :title
  attr_accessor :ftp_ota_dir
  attr_accessor :ftp_host
  attr_accessor :ftp_user
  attr_accessor :ftp_password
  attr_accessor :gmail_user
  attr_accessor :gmail_pass
  attr_accessor :reciever_mail_id
  attr_accessor :http_translation
  
  def initialize(attrs)
    @ipa_path = attrs['ipa_path']
    @icon_path = attrs['icon_path']
    @bundle_identifier = attrs['bundle_identifier']
    @bundle_version = attrs['bundle_version']
    @title = attrs['title']
    @ftp_ota_dir = attrs['ftp_ota_dir']
    @ftp_host = attrs['ftp_host']
    @ftp_user = attrs['ftp_user']
    @ftp_password = attrs['ftp_password']
    @gmail_user = attrs['gmail_user']
    @gmail_pass = attrs['gmail_pass']
    @reciever_mail_id = attrs['reciever_mail_id']
    @http_translation = attrs['http_translation']
  end
  
  def needsToRunAfterFinalized
    return true
  end
  
  def prebuild(build,listner)
  end
  

  def perform(build,launcher,listner)
      
      workspace_path = build.native.getProject.getWorkspace() #get the workspace path
      ipa_file = "#{workspace_path}/#{@ipa_path}"
      icon_file = "#{workspace_path}/#{@icon_path}"
      ipa_filename = File.basename ipa_file
      icon_filename = File.basename icon_file
      
      project = build.native.getProject.displayName
      build_number = build.native.getNumber()
      build_number = build_number.to_s
      ipa_url = "#{@http_translation}#{@ftp_ota_dir}#{project}/#{build_number}/#{ipa_filename}"
      icon_url =  "#{@http_translation}#{@ftp_ota_dir}#{project}/#{build_number}/#{icon_filename}"
           
      manifest_file = Manifest::create ipa_url,icon_url,@bundle_identifier,@bundle_version,@title,File.dirname(ipa_file)
     
      #begin
        FTP::upload @ftp_host, @ftp_user, @ftp_password, @ftp_ota_dir, project,build_number,[ipa_file,manifest_file] 
      #rescue
       # listner.error "FTP Connection Refused, check the FTP Settings"
       # build.halt
       #end
      
      manifest_filename = File.basename manifest_file
      itms_link = "itms-services://?action=download-manifest&url=#{@http_translation}#{@ftp_ota_dir}#{project}/#{build_number}/#{manifest_filename}"
      itms_link = itms_link.gsub /\s*/,''
      listner.info itms_link  
  end
        
end
