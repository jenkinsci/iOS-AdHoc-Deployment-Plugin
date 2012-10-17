# encoding: UTF-8

module Test::Reporters

  # Hash Abstract is a base class for the TAP-Y
  # and TAP-J reporters.
  #
  class AbstractHash < Abstract

    #
    # @return [Hash]
    #
    def begin_suite(suite)
      require 'yaml'
      require 'stringio'

      @start_time = Time.now
      @case_level = 0
      @test_index = 0

      now = Time.now.strftime('%Y-%m-%d %H:%M:%S')

      h = {
        'type'  => 'suite',
        'start' => now,
        'count' => total_count(suite)
      }

      h['seed'] = suite.seed if suite.respond_to?(:seed)

      return h
    end

    #
    # @return [Hash]
    #
    def begin_case(test_case)
      h = {}
      h['type' ] = 'case'
      h['level'] = @case_level

      merge_subtype h, test_case
      merge_setup   h, test_case
      merge_label   h, test_case

      @case_level += 1

      return h
    end

    #
    def begin_test(test)
      @test_index += 1

      @stdout, @stderr = $stdout, $stderr
      $stdout, $stderr = StringIO.new, StringIO.new
    end

    # Ruby Test use the term "skip", where as TAP-Y/J uses "omit".
    #
    # @todo Maybe the terms can ultimately be reconciled.
    #
    # @return [Hash]
    #
    def skip_test(test)
      h = {}
      h['type'  ] = 'test'
      h['status'] = 'omit'

      merge_subtype      h, test
      merge_setup        h, test
      merge_label        h, test
      #merge_comparison  h, test, exception
      #merge_coverage    h, test
      merge_source       h, test
      #merge_exception    h, test, exception
      merge_output       h
      merge_time         h

      return h
    end

    #
    # @return [Hash]
    #
    def pass(test) #, backtrace=nil)
      h = {}
      h['type'  ] = 'test'
      h['status'] = 'pass'

      merge_subtype      h, test
      merge_setup        h, test
      merge_label        h, test
      #merge_comparison  h, test, exception
      #merge_coverage    h, test
      merge_source       h, test
      merge_output       h
      merge_time         h

      return h
    end

    #
    # @return [Hash]
    #
    def fail(test, exception)
      h = {}
      h['type'  ] = 'test'
      h['status'] = 'fail'

      merge_subtype      h, test
      merge_priority     h, test, exception
      merge_setup        h, test
      merge_label        h, test
      #merge_comparison  h, test, exception
      #merge_coverage    h, test
      merge_source       h, test
      merge_exception    h, test, exception
      merge_output       h
      merge_time         h
 
      return h
    end

    #
    # @return [Hash]
    #
    def error(test, exception)
      h = {}
      h['type'  ] = 'test'
      h['status'] = 'error'

      merge_subtype      h, test
      merge_priority     h, test, exception
      merge_setup        h, test
      merge_label        h, test
      #merge_comparison  h, test, exception
      #merge_coverage    h, test
      merge_source       h, test
      merge_exception    h, test, exception, true
      merge_output       h
      merge_time         h

      return h
    end

    #
    # @return [Hash]
    #
    def todo(test, exception)
      h = {}
      h['type'  ]   = 'test'
      h['status']   = 'todo'

      merge_subtype      h, test
      merge_priority     h, test, exception
      merge_setup        h, test
      merge_label        h, test
      #merge_comparison  h, test, exception
      #merge_coverage    h, test
      merge_source       h, test
      merge_exception    h, test, exception
      merge_output       h
      merge_time         h

      return h
    end

    #
    def end_test(test)
      super(test)
      $stdout, $stderr = @stdout, @stderr
    end

    #
    def end_case(test_case)
      @case_level -= 1
    end

    #
    # @return [Hash]
    #
    def end_suite(suite)
      h = {
        'type'  => 'final',
        'time'  => Time.now - @start_time,
        'counts' => {
          'total' => total,
          'pass'  => record[:pass].size,
          'fail'  => record[:fail].size,
          'error' => record[:error].size,
          'omit'  => record[:omit].size,
          'todo'  => record[:todo].size
        }
      }
      return h
    end

  private

    # For todo entries in particulr, i.e. NotImplementedError
    # exception, the return value represents the "todo" priority
    # level. The `Exception#priority` method returns an Integer
    # to set the priority level higher or lower, where higher
    # the number the more urgent the priority.
    #
    def merge_priority(hash, test, exception)
      level = exception.priority
      h['priority'] = level.to_i
    end

    #
    def merge_subtype(hash, test)
      hash['subtype'] = test.type.to_s if test.respond_to?(:type)
    end

    # RubyTest uses the term `topic`, where as TAP-Y/J uses `setup`.
    def merge_setup(hash, test)
      #hash['setup'] = test.setup.to_s if test.respond_to?(:setup)
      hash['setup'] = test.topic.to_s if test.respond_to?(:topic)
    end

    # Add test description to hash.
    def merge_label(hash, test)
      hash['label'] = test.to_s.strip
    end

    # TODO: This is not presently used.
    def merge_comparison(hash, test, exception)
      hash['returned'] = exception.returned
      hash['expected'] = exception.expected
    end

    # Add source location information to hash.
    def merge_source(hash, test)
      if test.respond_to?('source_location')
        file, line = source_location
        hash['file'   ] = file
        hash['line'   ] = line
        hash['source' ] = code(file, line).to_str
        hash['snippet'] = code(file, line).to_omap
      end
    end

    # Add exception subsection of hash.
    def merge_exception(hash, test, exception, bt=false)
      hash['exception'] = {}
      hash['exception']['file'     ] = code(exception).file
      hash['exception']['line'     ] = code(exception).line
      hash['exception']['source'   ] = code(exception).to_str
      hash['exception']['snippet'  ] = code(exception).to_omap
      hash['exception']['message'  ] = exception.message
      hash['exception']['backtrace'] = clean_backtrace(exception) if bt
    end

    # TODO: This is still an "idea in progress" for both RybyTest and Tap-Y/J.
    #
    # There are a number of different types of code coverage.
    #
    #   http://en.wikipedia.org/wiki/Code_coverage
    #
    # If we were to provide this, we'd have LOC coverage, probably
    # given as a list of `file:from-to`, and UNIT coverage, a list
    # of classes/modules and methods addressed.
    #
    def merge_coverage(hash, test)
      loc, unit = nil, nil
      if test.respond_to?(:loc)
        loc = test.loc
      end
      if test.respond_to?(:unit)
        unit = test.unit
      end
      if loc or unit
        hash['coverage'] = {}
        hash['coverage']['loc']  = loc  if loc
        hash['coverage']['unit'] = unit if unit
      end
    end

    #
    def merge_output(hash)
      hash['stdout'] = $stdout.string
      hash['stderr'] = $stderr.string
    end

    #
    def merge_time(hash)
      hash['time'] = Time.now - @start_time
    end

  end

end
