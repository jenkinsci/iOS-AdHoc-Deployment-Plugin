#Jesly Varghese 2012
#FTP Module
#This class deals with the upload of ipa, manifest and icon to remote ftp server
#Improvement needed, support for SFTP, Upload to dropbox, or using dropbox as ipa host is 
#a viable option

require 'rubygems'
require 'net/ftp'

module FTP
  def self.upload(server, project, files)
    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect server[:hostname]
    ftp.login server[:username], server[:pass]
    ftp.chdir server[:upload_path]
    
    dir_contents = ftp.nlst
    ftp.mkdir project unless dir_contents.include? project[:name]
    
    ftp.chdir project[:name]
    ftp.mkdir project[:build_number]
    ftp.chdir project[:build_number]
    
    files.each do |file| 
       begin
        ftp.putbinaryfile file, File.basename(file)  
       rescue
        next
       end
    end
    
    ftp.quit
  end
end
