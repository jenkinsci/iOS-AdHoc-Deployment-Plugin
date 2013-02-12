require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'cfpropertylist'

#This classes opens a zip file and obtain the neccessary app bundling data from it

#This class get information from the IPA file 

class IPAFileData
  
  #I have no clue why this should be a class
  def binary_plist_of(ipa_path)
    ipaFile = Zip::ZipFile.open ipa_path # => returns an zipfile IPA's are basically a compressed file
    info_plist_path = "Payload/#{zipfile.dir.open('Payload').entries[0]}/Info.plist" #This is path to the Plist file, dirty hardcoded
    info_plist_path
  end
  
end


class IPA
  def initialize(binary_plist_path)
    #BOOM! Initialize this with path to plist, and you get every awesome piece of data you want
    cf_binary  =  CFPropertyList::Binary.new
    cf_plist   =  cf_binary.load binary_plist_path
    
  end
  
  # I need to add a bit of meta programming to query the plist properties
  
end