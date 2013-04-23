# encoding: UTF-8

module Test::Reporters

  # Simple Dot-Progress Reporter
  class Dotprogress < Abstract

    def skip_test(unit, reason)
      print "S".ansi(:cyan) if runner.verbose?
    end

    def pass(unit)
      print "."
      $stdout.flush
    end

    def fail(unit, exception)
      print "F".ansi(:red)
      $stdout.flush
    end

    def error(unit, exception)
      print "E".ansi(:red, :bold)
      $stdout.flush
    end

    def todo(unit, exception)
      print "P".ansi(:yellow)
      $stdout.flush
    end

    def end_suite(suite)
      puts; puts
      puts timestamp
      puts

      if runner.verbose?
        unless record[:omit].empty?
          puts "SKIPPED\n\n"
          record[:skip].each do |test, reason|
            puts "    #{test}".ansi(:bold)
            puts "    #{reason}" if String===reason
            puts
          end
        end
      end

      unless record[:todo].empty?
        puts "PENDING\n\n"
        record[:todo].each do |test, exception|
          puts "    #{test}".ansi(:bold) unless test.to_s.empty?
          puts "    #{exception}"
          puts "    #{file_and_line(exception)}"
          puts code(exception)
          puts
        end
      end

      unless record[:fail].empty?
        puts "FAILURES\n\n"
        record[:fail].each do |test_unit, exception|
          puts "    #{test_unit}".ansi(:bold)
          puts "    #{exception}"
          puts "    #{file_and_line(exception)}"
          puts code(exception)
          puts "    " + clean_backtrace(exception).join("\n    ")
          puts
        end
      end

      unless record[:error].empty?
        puts "ERRORS\n\n"
        record[:error].each do |test_unit, exception|
          puts "    #{test_unit}".ansi(:bold)
          puts "    #{exception}"
          puts "    #{file_and_line(exception)}"
          puts code(exception)
          puts "    " + clean_backtrace(exception).join("\n    ")
          puts
        end
      end

      puts tally
    end

  end

end
