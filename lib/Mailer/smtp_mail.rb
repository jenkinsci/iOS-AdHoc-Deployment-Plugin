#Jesly Varghese 2012

#Part of OTA-Builder and Uploader Plugin For iOS Project
#Developed as a part of CI-Project @ Sourcebits LLC

#SMTP class
#An SMTP Mail Class With Husdon Configuration


require "rubygems"
require "require_relative"
require "java"
require "pony"

java_import Java.hudson.tasks.Mailer

require_relative "configuration.rb"


class SMTP<MailConfiguration

	attr_accessor :mail

	def initialize(mail)
		mail_descriptor = Mail.descriptor()

		@user_name = mail_descriptor.getSmtpAuthUserName()
		@password  = mail_descriptor.getSmtpAuthPassword()
		@server    = mail_descriptor.getSmtpServer()
		@port      = mail_descriptor.getSmtpPort()
		
		@mail      = mail
	end

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

				:attachments => mail.attchments,

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