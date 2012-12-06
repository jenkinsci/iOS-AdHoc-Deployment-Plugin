require 'rubygems'
require 'require_relative'
require 'test/unit'

require_relative '../lib/mail_parser.rb'

class MailParserTest<Test::Unit::TestCase
	def test_substitute_variables
		content = "Hey everyone, we just love replaced parsing of {love} with you {girl_friend}"
		substituted_content = MailParser::substitute_variables(content) do
				[
					{
						:replace=>"{love}",
						:with=>"<3"
					},
					{
						:replace=>"{girl_friend}",
						:with=>"ann"
					}
				]
		end
		expected_content = 	"Hey everyone, we just love replaced parsing of <3 with you ann"
 		assert_equal expected_content,substituted_content
	end
end