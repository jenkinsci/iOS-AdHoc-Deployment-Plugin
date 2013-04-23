module Test

  # Recorder class is an observer that tracks all tests
  # that are run and categorizes them according to their
  # test status.
  class Recorder

    def initialize
      @table = Hash.new{ |h,k| h[k] = [] }
    end

    def [](key)
      @table[key.to_sym]
    end

    #
    def skip_test(test, reason)
      self[:skip] << [test, reason]
    end

    # Add `test` to pass set.
    def pass(test)
      self[:pass] << test
    end

    def fail(test, exception)
      self[:fail] << [test, exception]
    end

    def error(test, exception)
      self[:error] << [test, exception]
    end

    def todo(test, exception)
      self[:todo] << [test, exception]
    end

    #def omit(test, exception)
    #  self[:omit] << [test, exception]
    #end

    # Returns true if their are no test errors or failures.
    def success?
      self[:error].size + self[:fail].size > 0 ? false : true
    end

    # Ignore any other signals.
    def method_missing(*a)
    end

  end

end
