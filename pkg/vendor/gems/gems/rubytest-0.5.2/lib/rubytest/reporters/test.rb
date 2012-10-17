# encoding: UTF-8

module Test::Reporters

  # Test Reporter is used to test Ruby Test itself.
  #
  class Test < AbstractHash

    #
    def initialize(runner)
      super(runner)
    end

    #
    def begin_suite(suite)
      super(suite)
    end

    #
    def begin_case(test_case)
      super(test_case)
    end

    #
    def pass(test) #, backtrace=nil)
      super(test)
    end

    #
    def fail(test, exception)
      super(test, exception)
    end

    #
    def error(test, exception)
      super(test, exception)
    end

    #
    def todo(test, exception)
      super(test, exception)
    end

    #
    def end_suite(suite)
      super(suite)
    end

  end

end
