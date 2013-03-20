require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'cfpropertylist'

#This classes opens a zip file and obtain the neccessary app bundling data from it

#This class get information from the IPA file 

class IPAFileData
  
  #I have no clue why this should be a class
  def binary_plist_path_of(ipa_path)
    ipaFile = Zip::ZipFile.open ipa_path # => returns an zipfile IPA's are basically a compressed file
    info_plist_path = "Payload/#{ipaFile.dir.open('Payload').entries[0]}/Info.plist" #This is path to the Plist file, dirty hardcoded
    "#{ipa_path}/#{info_plist_path}"
  end
  
  def path_of_ipa_contents
    
  end
end


class IPA
  def initialize(binary_plist_path)
    #BOOM! Initialize this with path to plist, and you get every awesome piece of data you want
    cf_binary  =  CFPropertyList::List.new binary_plist_path
    @plist_data = CFPropertyList.native_types cf_binary
  end
  
  # I need to add a bit of meta programming to query the plist properties
  
  def method_missing(method, *params)
    return if @plist_data.nil?
    
    @plist_data.each do |key, value|
      value if key.downcase.match /#{method.downcase}/
    end
  end  
end
