class File

  #
  def self.localname(path)
    path.sub(Dir.pwd+'/','')
  end

end
