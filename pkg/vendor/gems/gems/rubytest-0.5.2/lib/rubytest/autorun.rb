#$TEST_SUITE = [] unless defined?($TEST_SUITE)

if RUBY_VERSION < '1.9'
  require 'rubytest'
else
  require_relative '../rubytest'
end

at_exit {
  suite   = $TEST_SUITE
  options = {
    :format => ENV['rubytest-format']  # TODO: better name?
  }

  runner  = Ruth::Test::Runner.new(suite, options)
  success = runner.run
  exit -1 unless success
}

