#Jesly Varghese 2012

#Part of OTA-Builder and Uploader Plugin For iOS Project
#Developed as a part of CI-Project @ Sourcebits LLC

#Mail Module
#This class sends a mail to the specified set of people.

#this could have been done in two ways, either use native java methods or go for rb methods
#i choose the latter

module Mail

	def mail
		#give values to all those subtle variables needed here.
		@charset = 'UTF-8'
		@text_part_charset = 'UTF-8'
		@headers = nil
	end

end



