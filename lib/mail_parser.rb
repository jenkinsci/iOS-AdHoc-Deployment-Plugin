require 'rubygems'
require 'maruku'

module MailParser
	def self.substitute_variables(content)
		replacement_table = yield
		replacement_table.each do |replacement_entry|
			content.gsub! /#{replacement_entry[:replace]}/, replacement_entry[:with]
		end
		content
	end

	def self.get_html(content)
		doc = Maruku.new content
		doc.to_html
	end

end