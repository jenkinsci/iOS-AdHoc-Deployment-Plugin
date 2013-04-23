module Test

  # The Test::Runner class handles the execution of tests.
  #
  class Runner

    # Default report is in the old "dot-progress" format.
    DEFAULT_FORMAT = 'dotprogress'

    # Exceptions that are not caught by test runner.
    OPEN_ERRORS = [NoMemoryError, SignalException, Interrupt, SystemExit]

    # / / / D E F A U L T S / / /

    # Default test suite ($TEST_SUITE).
    def self.suite
      $TEST_SUITE
    end

    # Default list of test files to load.
    def self.files
      @files ||= []
    end

    #
    def self.format
      @format || DEFAULT_FORMAT
    end

    #
    def self.format=(format)
      @format = format
    end

    #
    def self.verbose
      @verbose
    end

    #
    def self.verbose=(boolean)
      @verbose = !!boolean
    end

    # Default description match for filtering tests.
    def self.match
      @match ||= []
    end

    # Default selection of tags for filtering tests.
    def self.tags
      @tags ||= []
    end

    # Default selection of units for filtering tests.
    def self.units
      @unit ||= []
    end

    #
    def self.hard
      @hard
    end

    #
    def self.hard=(boolean)
      @hard = !!boolean
    end

    # / / / A T T R I B U T E S / / /

    # Test suite to run. This is a list of compliant test units and test cases.
    attr :suite

    # Test files to load.
    attr :files

    # Reporter format name, or name fragment, used to look up reporter class.
    attr :format

    #
    def format=(name)
      @format = name.to_s
    end

    # Matching text used to filter which tests are run.
    attr :match

    # Selected tags used to filter which tests are run.
    attr :tags

    # List of units with which to filter tests. It is an array of strings
    # which are matched against module, class and method names.
    attr :units

    # Show extra details in reports.
    def verbose?
      @verbose
    end

    #
    def verbose=(boolean)
      @verbose = !!boolean
    end

    # Use "hard" test mode?
    def hard?
      @hard
    end

    #
    def hard=(boolean)
      @hard = !!boolean
    end

    # Instance of Advice is a special customizable observer.
    def advice
      @advice
    end

    # Define universal before advice.
    def before(type, &block)
      advice.join_before(type, &block)
    end

    # Define universal after advice. Can be used by mock libraries,
    # for example to run mock verification.
    def after(type, &block)
      advice.join_after(type, &block)
    end

    # Define universal upon advice.
    #
    # See {Advice} for valid join-points.
    def upon(type, &block)
      advice.join(type, &block)
    end

    # New Runner.
    #
    # @param [Array] suite
    #   A list of compliant tests/testcases.
    #
    def initialize(options={}, &block)
      @suite     = options[:suite]   || self.class.suite
      @files     = options[:files]   || self.class.files
      @format    = options[:format]  || self.class.format
      @tags      = options[:tags]    || self.class.tags
      @units     = options[:units]   || self.class.units
      @match     = options[:match]   || self.class.match
      @verbose   = options[:verbose] || self.class.verbose
      @hard      = options[:hard]    || self.class.hard

      @advice    = Advice.new

      block.call(self) if block
    end

    # The reporter to use for ouput.
    attr :reporter

    # Record pass, fail, error and pending tests.
    attr :recorder

    # Array of observers, typically this just contains the recorder and
    # reporter instances.
    attr :observers

    # Run test suite.
    #
    # @return [Boolean]
    #   That the tests ran without error or failure.
    #
    def run
      ignore_callers

      files_resolved.each do |file|
        require file
      end

      @reporter  = reporter_load(format)
      @recorder  = Recorder.new

      @observers = [advice, @recorder, @reporter]

      #cd_tmp do
        observers.each{ |o| o.begin_suite(suite) }
        run_thru(suite)
        observers.each{ |o| o.end_suite(suite) }
      #end

      recorder.success?
    end

  private

    # Add to $RUBY_IGNORE_CALLERS.
    #
    # @todo Improve on this!
    def ignore_callers
      ignore_path   = File.expand_path(File.join(__FILE__, '../../..'))
      ignore_regexp = Regexp.new(Regexp.escape(ignore_path))

      $RUBY_IGNORE_CALLERS ||= {}
      $RUBY_IGNORE_CALLERS << ignore_regexp
      $RUBY_IGNORE_CALLERS << /bin\/rubytest/
    end

    #
    def run_thru(list)
      list.each do |t|
        if t.respond_to?(:each)
          run_case(t)
        elsif t.respond_to?(:call)
          run_test(t)
        else
          #run_note(t) ?
        end
      end
    end

    # Run a test case.
    #
    def run_case(tcase)
      if tcase.respond_to?(:skip?) && (reason = tcase.skip?)
        return observers.each{ |o| o.skip_case(tcase, reason) }
      end

      observers.each{ |o| o.begin_case(tcase) }

      if tcase.respond_to?(:call)
        tcase.call do
          run_thru( select(tcase) )
        end
      else
        run_thru( select(tcase) )
      end

      observers.each{ |o| o.end_case(tcase) }
    end

    # Run a test.
    #
    # @param [Object] test
    #   The test to run, must repsond to #call.
    #
    def run_test(test)
      if test.respond_to?(:skip?) && (reason = test.skip?)
        return observers.each{ |o| o.skip_test(test, reason) }
      end

      observers.each{ |o| o.begin_test(test) }
      begin
        success = test.call
        if hard? && !success  # TODO: separate run_test method to speed things up?
          raise Assertion, "failure of #{test}"
        else
          observers.each{ |o| o.pass(test) }
        end
      rescue *OPEN_ERRORS => exception
        raise exception
      rescue NotImplementedError => exception
        #if exception.assertion?  # TODO: May require assertion? for todo in future
          observers.each{ |o| o.todo(test, exception) }
        #else
        #  observers.each{ |o| o.error(test, exception) }
        #end
      rescue Exception => exception
        if exception.assertion?
          observers.each{ |o| o.fail(test, exception) }
        else
          observers.each{ |o| o.error(test, exception) }
        end
      end
      observers.each{ |o| o.end_test(test) }
    end

    # TODO: Make sure this filtering code is correct for the complex 
    #       condition that that ordered testcases can't have their tests
    #       filtered individually (since they may depend on one another).

    # Filter cases based on selection criteria.
    #
    # @return [Array] selected test cases
    def select(cases)
      selected = []
      if cases.respond_to?(:ordered?) && cases.ordered?
        cases.each do |tc|
          selected << tc
        end
      else
        cases.each do |tc|
          next if tc.respond_to?(:skip?) && tc.skip?
          next if !match.empty? && !match.any?{ |m| m =~ tc.to_s }

          if !units.empty?
            next unless tc.respond_to?(:unit)
            next unless units.find{ |u| tc.unit.start_with?(u) }
          end

          if !tags.empty?
            next unless tc.respond_to?(:tags)
            tc_tags = [tc.tags].flatten.map{ |t| t.to_s }
            next if (tags & tc_tags).empty?
          end

          selected << tc
        end
      end
      selected
    end

    # Get a reporter instance be name fragment.
    #
    # @return [Reporter::Abstract]
    #   The test reporter instance.
    #
    def reporter_load(format)
      format = DEFAULT_REPORT_FORMAT unless format
      format = format.to_s.downcase
      name   = reporter_list.find{ |r| /^#{format}/ =~ r }

      raise "unsupported report format" unless format

      if RUBY_VERSION < '1.9'
        require "rubytest/reporters/#{name}"
      else
        require_relative "reporters/#{name}"
      end

      reporter = Test::Reporters.const_get(name.capitalize)
      reporter.new(self)
    end

    # Returns a list of available report types.
    #
    # @return [Array<String>]
    #   The names of available reporters.
    #
    def reporter_list
      list = Dir[File.dirname(__FILE__) + '/reporters/*.rb']
      list = list.map{ |r| File.basename(r).chomp('.rb') }
      list = list.reject{ |r| /^abstract/ =~ r }
      list.sort
    end

    # Files can be globs and directories which need to be
    # resolved to a list of files.
    #
    def files_resolved
      list = files.flatten
      list = list.map{ |f| Dir[f] }.flatten
      list = list.map{ |f| File.directory?(f) ? Dir[File.join(f, '**/*.rb')] : f }
      list = list.flatten.uniq
      list = list.map{ |f| File.expand_path(f) } 
      list
    end

=begin
  # TODO ?
  def cd_tmp(&block)
    dir = Test::Config.root + '/tmp'
    if Directory.exist?(dir)
      dir = File.join(dir, 'test')
      FileUtils.mkdir(dir) unless File.exist?(dir)
    else
      dir = File.join(Dir.tmpdir)
    end

    Dir.chdir(dir, &block)
  end
=end

  end

end
