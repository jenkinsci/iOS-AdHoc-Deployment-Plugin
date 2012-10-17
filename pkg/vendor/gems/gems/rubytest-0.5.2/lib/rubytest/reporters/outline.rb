# encoding: UTF-8

module Test::Reporters

  # 
  class Outline < Abstract

    #
    def begin_suite(suite)
      @tab   = 0
      @start_time = Time.now
      @start_test_cache = {}

      timer_reset
    end

    #
    def begin_case(tc)
      lines = tc.to_s.split("\n")
      label = lines.shift
      if tc.respond_to?(:type)
        tabs "#{tc.type}: #{label}".ansi(:bold)
        tabs lines.join("\n"), 2 unless lines.empty?
      else
        tabs "#{label}".ansi(:bold)
        tabs lines.join("\n"), 2 unless lines.empty?
      end
      @tab += 2
    end

    #
    def begin_test(test)
       if test.respond_to?(:topic) && test.topic
         topic = test.topic.to_s
         @start_test_cache[topic] ||= (
           tabs "#{topic}"
           true
         )
       end
       timer_reset
    end

    #
    #
    def pass(test)
      tabs "#{test}".ansi(:green)
    end

    #
    def fail(test, exception)
      tabs "#{test}".ansi(:red)

      s = []
      s << "#{exception}"
      s << "#{file_and_line(exception)}"
      s << code(exception)
      #puts "    #{exception.backtrace[0]}"
      tabs s.join("\n"), 4
    end

    #
    def error(test, exception)
      tabs "#{test}".ansi(:red, :bold)

      s = []
      s << "#{exception.class}"
      s << "#{exception}"
      s << "#{file_and_line(exception)}"
      s << code(exception)
      #s << trace.join("\n") unless trace.empty?
      tabs s.join("\n"), 4
    end

    #
    def todo(test, exception)
      tabs "#{test}".ansi(:yellow)
      tabs "#{file_and_line(exception)}", 4
    end

    #
    def omit(test, exception)
      tabs "#{test}".ansi(:cyan)
    end

    #
    def end_case(tcase)
      @tab -= 2
    end

    #
    def end_suite(suite)
      puts

      #unless record[:omit].empty?
      #  puts "\nOMITTED:\n\n"
      #  puts record[:omit].map{ |u| u.to_s }.sort.join('  ')
      #  puts
      #end

      #unless record[:todo].empty?
      #  puts "\nPENDING:\n\n"
      #  record[:pending].each do |test, exception|
      #    puts "#{test}".tabto(4)
      #    puts "#{file_and_line(exception)}".tabto(4)
      #    puts
      #  end
      #end

      #unless record[:fail].empty?
      #  puts "\nFAILURES:\n\n"
      #  record[:fail].reverse_each do |test, exception|
      #
      #    s = []
      #    s << "#{test}".ansi(:red)
      #    s << "#{file_and_line(exception)}".ansi(:bold)
      #    s <<  "#{exception}"
      #    s <<  code_snippet(exception)
      #    #puts "    #{exception.backtrace[0]}"
      #    puts s.join("\n").tabto(4)
      #  end
      #end

      #unless record[:error].empty?
      #  puts "\nERRORS:\n\n"
      #  record[:error].reverse_each do |test, exception|
      #    trace = clean_backtrace(exception)[1..-1]
      # 
      #     s = []
      #    s << "#{test}".ansi(:red, :bold)
      #    s << "#{exception.class} @ #{file_and_line(exception)}".ansi(:bold)
      #    s << "#{exception}"
      #    s << code_snippet(exception)
      #    #s << trace.join("\n") unless trace.empty?
      #    puts s.join("\n").tabto(4)
      #  end
      #end

      puts
      puts timestamp
      puts
      puts tally
    end

    #
    def clock
      secs = Time.now - @start_time
      return "%0.5fs" % [secs.to_s]
    end

    #
    def timer
      secs  = Time.now - @time
      @time = Time.now
      return "%0.5fs" % [secs.to_s]
    end

    #
    def timer_reset
      @time = Time.now
    end

    #
    def tabs(str, indent=0)
      if str
        puts(str.tabto(@tab + indent))
      else
        puts
      end
    end

  end

end




=begin
      if cover?

        unless uncovered_cases.empty?
          unc = uncovered_cases.map do |mod|
            yellow(mod.name)
          end.join(", ")
          puts "\nUncovered Cases: " + unc
        end

        unless uncovered_units.empty?
          unc = uncovered_units.map do |unit|
            yellow(unit)
          end.join(", ")
          puts "\nUncovered Units: " + unc
        end

        #unless uncovered.empty?
        #  unc = uncovered.map do |unit|
        #    yellow(unit)
        #  end.join(", ")
        #  puts "\nUncovered: " + unc
        #end

        unless undefined_units.empty?
          unc = undefined_units.map do |unit|
            yellow(unit)
          end.join(", ")
          puts "\nUndefined Units: " + unc
        end

      end
=end

