require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'cfpropertylist'

#This classes opens a zip file and obtain the neccessary app bundling data from it

#This class get information from the IPA file 

class IPAFileData
  
  #I have no clue why this should be a class
  def payload_path_of(ipa_path)
    ipaFile = Zip::ZipFile.open ipa_path # => returns an zipfile IPA's are basically a compressed file
    payload_path = "Payload/#{ipaFile.dir.open('Payload').entries[0]}/"
    payload_path
  end
  
  def binary_plist_path_of(ipa_path)
    ipaFile = Zip::ZipFile.open ipa_path # => returns an zipfile IPA's are basically a compressed file
    payload_path = payload_path_of ipa_path
    info_plist_path = "#{payload_path}Info.plist" #This is path to the Plist file, dirty hardcoded
    info_plist_path
  end
  
  def contents_of_infoplist(info_plist_path,ipa_path)
    Zip::ZipFile.open  ipa_path do |zipFile|
      zipFile.file.read info_plist_path
    end
  end
  
  def path_to_icon_file_with_name(icon_file_name, ipa_path)
    
    payload_path = payload_path_of ipa_path
    current_time = Time.new
    utc_sec = current_time.to_i.to_s
    destination_path = "/tmp/#{utc_sec}-#{icon_file_name}"
    Zip::ZipFile.open ipa_path do |zipFile|
      zipFile.extract "#{payload_path}#{icon_file_name}", destination_path
    end
    destination_path
  end
end


class IPA
  def initialize(binary_plist)
    #BOOM! Initialize this with path to plist, and you get every awesome piece of data you want
    cf_binary  =  CFPropertyList::List.new.load_binary_str binary_plist
    @plist_data = CFPropertyList.native_types cf_binary
  end
  

  def method_missing(method, *params)
    return if @plist_data.nil?
    
    @plist_data.each do |key, value|
      key_string = key.to_s
      method_string = method.to_s
      return value if key_string.downcase.match /#{method_string.downcase}/
    end
    return nil
  end  
end
