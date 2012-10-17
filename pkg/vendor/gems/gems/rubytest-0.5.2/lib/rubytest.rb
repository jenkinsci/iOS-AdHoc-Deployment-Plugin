# Ruby Test - a Universal Ruby Test Harness

$TEST_SUITE          = [] unless defined?($TEST_SUITE)
$RUBY_IGNORE_CALLERS = [] unless defined?($RUBY_IGNORE_CALLERS)

#require 'brass'  # TODO: Should we require BRASS ?
require 'ansi/core'

if RUBY_VERSION < '1.9'
  require 'rubytest/core_ext'
  require 'rubytest/code_snippet'
  require 'rubytest/config'
  require 'rubytest/rc'
  require 'rubytest/recorder'
  require 'rubytest/advice'
  require 'rubytest/runner'
  require 'rubytest/cli'
  require 'rubytest/reporters/abstract'
  require 'rubytest/reporters/abstract_hash'
else
  require_relative 'rubytest/core_ext'
  require_relative 'rubytest/code_snippet'
  require_relative 'rubytest/config'
  require_relative 'rubytest/rc'
  require_relative 'rubytest/recorder'
  require_relative 'rubytest/advice'
  require_relative 'rubytest/runner'
  require_relative 'rubytest/cli'
  require_relative 'rubytest/reporters/abstract'
  require_relative 'rubytest/reporters/abstract_hash'
end

