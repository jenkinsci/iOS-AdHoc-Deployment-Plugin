# encoding: UTF-8

module Test::Reporters

  # TAP-J Reporter
  #
  class Tapj < AbstractHash

    REVISION = 5

    #
    def initialize(runner)
      require 'json'
      super(runner)
    end

    #
    def begin_suite(suite)
      hash = super(suite)
      hash['rev'] = REVISION
      puts hash.to_json
    end

    #
    def begin_case(test_case)
      puts super(test_case).to_json
    end

    #
    def pass(test) #, backtrace=nil)
      puts super(test).to_json
    end

    #
    def fail(test, exception)
      puts super(test, exception).to_json
    end

    #
    def error(test, exception)
      puts super(test, exception).to_json
    end

    #
    def todo(test, exception)
      puts super(test, exception).to_json
    end

    #
    def end_suite(suite)
      puts super(suite).to_json
      puts "..."
    end

  end

end
