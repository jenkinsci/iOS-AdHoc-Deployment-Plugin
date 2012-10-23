#searches for .ipa file in give path, recurses into directory until it fails or finds an .ipa file

require 'rubygems'

module IPASearch
  def self.find_in(directory_path)
   unless (file = check_file(directory_path)).nil?
     return "#{directory_path}/#{file}"
   else
     dirs = get_dirs directory_path
     dirs.each {|dir| in_dir = find_in dir if in_dir.nil? } 
     return nil
   end
  end
  
  def self.check_file(dir_path)
    files = Dir.entries dir_path
    files.each {|file| return file if file.match /.+\.ipa/}
    return nil
  end
  
  def self.get_dirs(dir_path)
    dirs = []
    Dir.foreach(dir_path) do  |file| 
      next if (file=='.' || file=='..')
      dirs<<"#{dir_path}/#{file}" if File.directory?("#{dir_path}/#{file}")
    end
    return dirs
  end
end

p IPASearch::find_in '/Users/Shared/Jenkins/Home/jobs/GeoData/'
