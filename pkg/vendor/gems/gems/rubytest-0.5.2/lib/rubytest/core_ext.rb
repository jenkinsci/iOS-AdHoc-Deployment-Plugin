if RUBY_VERSION < '1.9'
  require 'rubytest/core_ext/assertion'
  require 'rubytest/core_ext/exception'
  require 'rubytest/core_ext/file'
  require 'rubytest/core_ext/string'
else
  require_relative 'core_ext/assertion'
  require_relative 'core_ext/exception'
  require_relative 'core_ext/file'
  require_relative 'core_ext/string'
end
