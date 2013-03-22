#IPA Scan and Find test
require 'rubygems'
require 'require_relative'
require_relative '../lib/ipa_search.rb'
require_relative '../lib/data_from_ipa.rb'

ipa_file_data = IPAFileData.new
file_path = "/Users/jesly/Workspace/Work/SVN/trunk/Development/Builds/Build 3/FitOrbit.ipa"
ipa = ipa_file_data.binary_plist_path_of file_path
plist_contents =ipa_file_data.contents_of_infoplist ipa, file_path
plist = IPA.new plist_contents

p plist.displayname
p ipa_file_data.path_to_icon_file_with_name plist.icon, file_path
