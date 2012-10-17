# encoding: UTF-8

module Test::Reporters

  # Classic TAP Reporter
  #
  # This reporter conforms to v12 of TAP. It could do with some
  # imporvements yet, and eventually upgraded to v13 of standard.
  class Tap < Abstract

    #
    def begin_suite(suite)
      @start_time = Time.now
      @i = 0
      @n = total_count(suite)
      puts "1..#{@n}"
    end

    def begin_test(test)
      @i += 1
    end

    #
    def pass(test)
      puts "ok #{@i} - #{test}"
    end

    #
    def fail(test, exception)
      puts "not ok #{@i} - #{test}"
      puts "  FAIL #{exception.class}"
      puts "  #{exception}"
      puts "  #{clean_backtrace(exception)[0]}"
    end

    #
    def error(test, exception)
      puts "not ok #{@i} - #{test}"
      puts "  ERROR #{exception.class}"
      puts "  #{exception}"
      puts "  " + clean_backtrace(exception).join("\n        ")
    end

    #
    def todo(test, exception)
      puts "not ok #{@i} - #{test}"
      puts "  PENDING"
      puts "  #{clean_backtrace(exception)[1]}"
    end

    #
    def omit(test, exception)
      puts "ok #{@i} - #{test}"
      puts "  OMIT"
      puts "  #{clean_backtrace(exception)[1]}"
    end

  end

end

