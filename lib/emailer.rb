require 'rubygems'
require 'gmail'

module Emailer
  def self.send(username,password,reciever_mail_id,itms_link)
    Gmail.connect(username,password) do |gmail|
      gmail.deliver do
        to reciever_mail_id
        
        subject 'A new build for your product is available'
        
        text_part do
          body "A new build is available for download at #{itms_link}"
        end
        
        html_part do
          content_type 'text/html; charset=UTF-8'
          body "<p>Hi,</p><p>A new build is avaiable for <a href='#{itms_link}'>download</a></p>Regards,<br/>Jenkins"
        end
        
      end
    end
  end
end
