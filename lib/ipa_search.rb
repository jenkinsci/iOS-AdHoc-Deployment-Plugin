#searches for .ipa file in give path, recurses into directory until it fails or finds an .ipa file

require 'rubygems'
require 'find'
module IPASearch
  def self.find_in(in_directory)
    Find.find(in_directory) { |path| return path if path.match(/.+\.ipa/)}
    return nil
  end
end

