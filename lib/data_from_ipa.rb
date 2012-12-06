require 'rubygems'
require 'zip/zip'

#This classes opens a zip file and obtain the neccessary app bundling data from it

class IPAData
  def initialize(ipa_path) 
  end
  
  def appFolder
    #Get the neccessary data path from the app folder path returned
  end
  
  def payLoadFolder
    #
  end
  
  def unzippedIPA(ipa_path)
    #Unzip the Ipa file and provide path to the Payload folder
    unzip_path = "/tmp/"
    Zip::ZipFile.open(ipa_path) do |zipfile|
      Zip::ZipFile.open(ipa_path).extract(zipfile,unzip_path,)
    end
  end
end