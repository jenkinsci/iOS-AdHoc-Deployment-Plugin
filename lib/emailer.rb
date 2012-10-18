require 'rubygems'
require 'gmail'


  username = ARGV[0]
  password = ARGV[1]
  reciever_mail_id = ARGV[2]
  itms_link = ARGV[3]
    Gmail.connect(username,password) do |gmail|

      email = gmail.compose do
        
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
      
    gmail.deliver email
   end
   
  
