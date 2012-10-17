begin
  require 'rc/api'
  RC.configure 'rubytest' do |config|
    Test.run(config.profile, &config)
  end
rescue LoadError
end

