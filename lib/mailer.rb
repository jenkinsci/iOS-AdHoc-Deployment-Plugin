#Jesly Varghese 2012

#Part of OTA-Builder and Uploader Plugin For iOS Project
#Developed as a part of CI-Project @ Sourcebits LLC

#Mailer class
#This class sends a mail to the specified set of people.

require "rubygems"
require "java"
require "pony"

java_import hudson.tasks.Mailer

#this could have been done in two ways, either use native java methods or go for rb methods
#i choose the latter

class Mail
  
  attr_accessor :to, :cc, :bcc, :from, :body, :html_body, :subject, :charset, :text_part_charset, :attachments, :headers, :sender, :reply_to
  
end

class MailConfiguration

	attr_accessor :user_name, :password, :server, :port

end
class SMTP<MailConfiguration
	
  attr_accessor :mail
  
  def send
		Pony.mail({
				:to => mail.to,
				:cc => mail.cc,
				:bcc=> mail.bcc,

				:from=>mail.from,

				:body => mail.body,
				:html_body => mail.html_body,

				:subject => mail.subject,

				:charset => mail.charset,
				:text_part_charset => mail.text_part_charset,

				:attchments => mail.attchments,

				:headers => mail.headers,
				:sender => mail.sender,
				:reply_to => mail.reply_to,

				:via =>:smtp,
				:via_options =>{
					:address => @server,
					:port    => @port,
					:enable_starttls_auto => true,
					:user_name => @user_name,
					:password => @password,
					:authentication => :plain

				}
			})
	end
  
end

class JenkinsSMTP<SMTP

	def initialize(mail)
		
    super 
    
    mail_descriptor = Mail.descriptor()

		@user_name = mail_descriptor.getSmtpAuthUserName()
		@password  = mail_descriptor.getSmtpAuthPassword()
		@server    = mail_descriptor.getSmtpServer()
		@port      = mail_descriptor.getSmtpPort()
		
		@mail      = mail
	end

end