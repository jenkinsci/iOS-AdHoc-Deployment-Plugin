require 'rubygems'
require 'net/ftp'

module FTP
  def self.upload(hostname,username,pass,upload_path,files)
    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect hostname
    ftp.login username, pass
    ftp.chdir upload_path
    files.each { |file| ftp.putbinaryfile(file,File.basename(file)) }
    ftp.quit
  end
end
