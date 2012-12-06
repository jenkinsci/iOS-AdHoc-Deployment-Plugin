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

	def initialize
		mail_descriptor = Java.hudson.tasks.Mailer.descriptor()
		@user_name = mail_descriptor.getSmtpAuthUserName()
		@password  = mail_descriptor.getSmtpAuthPassword()
		@server    = mail_descriptor.getSmtpServer()
		@port      = mail_descriptor.getSmtpPort()
	end
  
end