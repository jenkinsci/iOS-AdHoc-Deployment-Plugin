# encoding: UTF-8

module Test

  #
  module Reporters

    # Test Reporter Base Class
    class Abstract

      #
      def self.inherited(base)
        registry << base
      end

      #
      def self.registry
        @registry ||= []
      end

      #
      def initialize(runner)
        @runner = runner
        #@source = {}

        # in case start_suite is overridden
        @start_time = Time.now
      end

      #
      attr :runner

      #
      def begin_suite(test_suite)
        @start_time = Time.now
      end

      #
      def begin_case(test_case)
      end

      #
      def begin_test(test)
      end

      #
      def skip_case(test_case)
      end

      #
      def skip_test(test)
      end

      #
      #def test(test)
      #end

      #
      def pass(test)
      end

      #
      def fail(test, exception)
      end

      # Report a test error.
      def error(test, exception)
      end

      # Report a pending test.
      def todo(test, exception)
      end

      #
      def end_test(test)
      end

      #
      def end_case(test_case)
      end

      #
      def end_suite(test_suite)
      end

    protected

      def record
        runner.recorder
      end

      # Is coverage information requested?
      #def cover?
      #  runner.cover?
      #end

      # Count up the total number of tests.
      def total_count(suite)
        c = 0
        suite.each do |tc|
          if tc.respond_to?(:each)
            c += total_count(tc)
          else
            c += 1
          end
        end
        return c
      end

      # Common timestamp any reporter can use.
      def timestamp
        seconds = Time.now - @start_time

        "Finished in %.5fs, %.2f tests/s." % [seconds, total/seconds]
      end

      #
      def total
        @total ||= subtotal
      end

      #
      def subtotal
        [:todo, :pass, :fail, :error, :omit, :skip].inject(0) do |s,r|
          s += record[r.to_sym].size; s
        end
      end

      # TODO: lump skipped and omitted into one group ?

      TITLES = {
        :pass  => 'passing',
        :fail  => 'failures',
        :error => 'errors',
        :todo  => 'pending',
        :omit  => 'omissions',
        :skip  => 'skipped'
      }

      # TODO: Add assertion counts (if reasonably possible).

      # Common tally stamp any reporter can use.
      #
      # @return [String] tally stamp
      def tally
        sizes  = {}
        names  = %w{pass error fail todo omit skip}.map{ |n| n.to_sym }
        names.each do |r|
          sizes[r] = record[r].size
        end

        #names.unshift(:tests)
        #sizes[:tests] = total

        s = []
        names.each do |n|
          next unless sizes[n] > 0
          s << tally_item(n, sizes)
        end

        'Executed ' + "#{total}".ansi(:bold) + ' tests with ' + s.join(', ') + '.'
      end

      #
      def tally_item(name, sizes)
        x = []
        x << "%s" % sizes[name].to_s.ansi(:bold)
        x << " %s" % TITLES[name].downcase
        x << " (%.1f%%)" % ((sizes[name].to_f/total*100)) if runner.verbose?
        x.join('')
      end

      #--
      # TODO: Matching `bin/ruby-test` is not robust.
      #++

      # Remove reference to lemon library from backtrace.
      #
      # @param [Exception] exception
      #   The error that was rasied.
      #
      # @return [Array] filtered backtrace
      def clean_backtrace(exception)
        trace = (Exception === exception ? exception.backtrace : exception)
        return trace if $DEBUG
        trace = trace.reject{ |t| $RUBY_IGNORE_CALLERS.any?{ |r| r =~ t }}
        trace = trace.map do |t|
          i = t.index(':in')
          i ? t[0...i] : t
        end
        #if trace.empty?
        #  exception
        #else
        #  exception.set_backtrace(trace) if Exception === exception
        #  exception
        #end
        trace.uniq.map{ |bt| File.localname(bt) }
      end

      # That an exception, backtrace or source code text and line
      # number and return a CodeSnippet object.
      #
      # @return [CodeSnippet] code snippet
      def code(source, line=nil)
        case source
        when Exception
          CodeSnippet.from_backtrace(clean_backtrace(source.backtrace))
        when Array
          CodeSnippet.from_backtrace(clean_backtrace(source))
        else
          CodeSnippet.new(source, line)
        end
      end

      #
      def file_and_line(exception)
        line = clean_backtrace(exception)[0]
        return "" unless line
        i = line.rindex(':in')
        line = i ? line[0...i] : line
        File.localname(line)
      end

      #
      def file_and_line_array(exception)
        case exception
        when Exception
          line = exception.backtrace[0]
        else
          line = exception[0] # backtrace
        end
        return ["", 0] unless line
        i = line.rindex(':in')
        line = i ? line[0...i] : line
        f, l = File.localname(line).split(':')
        return [f, l.to_i]
      end

      #
      def file(exception)
        file_and_line_array(exception).first
      end

      #
      def line(exception)
        file_and_line_array(exception).last
      end

    end

  end

end
