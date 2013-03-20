#IPA Scan and Find test
require_relative '../lib/ipa_search.rb'
require_relative '../lib/data_from_ipa.rb'

ipa_file_data = IPAFileData.new
ipa = IPA.new ipa_file_data.binary_plist_path_of "/Users/jesly/Workspace/Work/SVN/trunk/Development/Builds/Build 3/FitOrbit.ipa"