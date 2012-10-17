# encoding: UTF-8

module Test::Reporters

  # Progess reporter gives test counter, precentage and times.
  #
  class Progress < Abstract

    #
    def begin_suite(suite)
      @tab   = 0
      @total_count = total_count(suite)
      @start_time  = Time.now
      @test_cache  = {}
      @count       = 0

      max = @total_count.to_s.size

      @layout_head = " %3u%%  %#{max}s %#{max}s  %8s %11s  %1s  %s"
      @layout      = " %3u%%  %#{max}u/%#{max}u  %8s %11s  %1s  %s"

      timer_reset
    end

    #
    def begin_case(tc)
      #tabs tc.to_s.ansi(:bold)
      show_header(' ', tc.to_s)
      @tab += 2
    end

    #
    def begin_test(test)
       if test.respond_to?(:topic) && test.topic
         topic = test.topic.to_s.rstrip
         @test_cache[topic] ||= (
           show_header(' ', topic) unless topic.empty?
           true
         )
       end
       timer_reset
    end

    #
    def pass(test)
      show_line(".", test, :green)
    end

    #
    def fail(test, exception)
      show_line("F", test, :red)
    end

    #
    def error(test, exception)
      show_line("E", test, :red)
    end

    #
    def todo(test, exception)
      show_line("P", test, :yellow)
    end

    #
    def omit(test, exception)
      show_line("O", test, :cyan)
    end

    #
    def end_case(tcase)
      @tab -= 2
    end

    #
    def end_suite(suite)
      puts

      if runner.verbose?
        unless record[:omit].empty?
          puts "OMISSIONS:\n\n"
          record[:omit].reverse_each do |test, exception|
            s = []
            s << "#{test}".ansi(:bold)
            s << "#{file_and_line(exception)}"
            puts s.join("\n").tabto(4)
            puts code(exception).to_s.tabto(7)
            puts
          end
        end
      end

      unless record[:todo].empty?
        puts "PENDING:\n\n"
        record[:todo].reverse_each do |test, exception|
          s = []
          s << "#{test}".ansi(:bold)
          s << "#{file_and_line(exception)}"
          puts s.join("\n").tabto(4)
          puts code(exception).to_s.tabto(7)
          puts
        end
      end

      unless record[:fail].empty?
        puts "FAILURES:\n\n"
        record[:fail].reverse_each do |test, exception|
          s = []
          s << "#{test}".ansi(:bold)
          s << "#{exception}".ansi(:red)
          s << "#{file_and_line(exception)}"
          puts s.join("\n").tabto(4)
          puts code(exception).to_s.tabto(7)
          #puts "    #{exception.backtrace[0]}"
          puts
        end
      end

      unless record[:error].empty?
        puts "ERRORS:\n\n"
        record[:error].reverse_each do |test, exception|
          trace = clean_backtrace(exception)[1..-1].map{ |bt| bt.sub(Dir.pwd+'/', '') }
          s = []
          s << "#{test}".ansi(:bold)
          s << "#{exception.class}".ansi(:red)
          s << "#{exception}".ansi(:red)
          s << "#{file_and_line(exception)}"
          puts s.join("\n").tabto(4)
          puts code(exception).to_s.tabto(7)
          puts trace.join("\n").tabto(4) unless trace.empty?
          puts
        end
      end

      puts
      puts timestamp
      puts
      puts tally
    end

  private

    #
    def show_header(status, text)
      text = text[0..text.index("\n")||-1]
      data = [prcnt, ' ', ' ', clock, timer, status, (' ' * @tab) + text.to_s]
      #puts (" " * @tab) + (@layout_head % data)
      puts (@layout_head % data).ansi(:bold)
    end

    #
    def show_line(status, test, color)
      @count += 1
      data = [prcnt, @count, @total_count, clock, timer, status, (' ' * @tab) + test.to_s]
      #puts (" " * @tab) + (@layout % data)
      puts (@layout % data).ansi(color)
    end

    #
    def prcnt
      ((@count.to_f / @total_count) * 100).round.to_s
    end

    #
    def clock
      secs  = Time.now - @start_time
      m, s  = secs.divmod(60)
      #s, ms = s.divmod(1)
      #ms = ms * 1000
      return "%u:%02u" % [m, s]
    end

    #
    def timer
      secs  = Time.now - @time
      @time = Time.now
      return "%0.5fs" % secs
    end

    #
    def timer_reset
      @time = Time.now
    end

    #
    def tabs(str=nil)
      if str
        puts(str.tabto(@tab))
      else
        puts
      end
    end

  end

end
