#Jesly Varghese 2012

#Part of OTA-Builder and Uploader Plugin For iOS Project
#Developed as a part of CI-Project @ Sourcebits LLC

#Mailer class
#This class sends a mail to the specified set of people.

require "rubygems"
require "require_relative"

require_relative "Mailer/smtp_mail.rb"
require_relative "Mailer/mail.rb"

class JenkinsMail<Mail
  
  def compose
    yield @mail
  end
  
  def send
    smtp_mail = SMTP.new(mail)
    smtp_mail.send
  end
end