require 'rubygems'
require 'net/ftp'

module FTP
  def self.upload(hostname,username,pass,upload_path,project,build_number,files)
    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect hostname
    ftp.login username, pass
    ftp.chdir upload_path
    
    dir_contents = ftp.nlst
    ftp.mkdir project unless dir_contents.include? project
    
    ftp.chdir project
    ftp.mkdir build_number
    ftp.chdir build_number
    
    files.each { |file| ftp.putbinaryfile file, File.basename(file)  }
    
    ftp.quit
  end
end
