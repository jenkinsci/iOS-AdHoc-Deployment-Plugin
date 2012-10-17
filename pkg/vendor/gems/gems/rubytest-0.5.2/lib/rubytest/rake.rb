require 'rake/tasklib'

module Ruth

  #
  module Rake

    # TODO: The test task uses #fork. Maybe it should shell out instead?
    #  Or provide the option for either?

    # Define a test rake task.
    #
    # The `TEST` environment variable can be used to select tests
    # when using the task.
    #
    class TestTask < ::Rake::TaskLib

      # Glob patterns are used by default to select test scripts.
      DEFAULT_TESTS = [
        'test/**/case_*.rb',
        'test/**/*_case.rb',
        'test/**/test_*.rb',
        'test/**/*_test.rb'
      ]

      # Test scripts to load. Can be a file glob.
      attr_accessor :tests

      # Paths to add to $LOAD_PATH.
      attr_accessor :loadpath

      # Scripts to load prior to loading tests.
      attr_accessor :requires

      # Report format to use.
      attr_accessor :format

      # Filter tests based by tags.
      attr_accessor :tags

      # Filter tests by matching description.
      attr_accessor :match

      # From Rake's own TestTask.
      alias_method :libs, :loadpath
      alias_method :test_files, :tests

      #
      def initialize(name='test', desc="run tests", &block)
        @name       = name
        @desc       = desc

        @loadpath   = ['lib']
        @requires   = []
        @tests      = [ENV['TEST'] || DEFAULT_TESTS].flatten
        @format     = nil
        @match      = nil
        @tags       = []

        block.call(self)

        define_task
      end

      #
      def define_task
        desc @desc
        task @name do
          @tests ||= default_tests
          run
        end
      end

      #
      def run
        fork {
          #require 'test'
          require 'test/runner'

          loadpath.each   { |d| $LOAD_PATH.unshift(d) }
          requires.each   { |f| require f }
          test_files.each { |f| require f }

          suite   = $TEST_SUITE || []
          runner  = new(suite, :format=>format, :tags=>tags, :match=>match)
          success = runner.run

          exit -1 unless success
        }
        Process.wait
      end

      # Resolve test globs.
      #--
      # TODO: simplify?
      #++
      def test_files
        files = tests
        files = files.map{ |f| Dir[f] }.flatten
        files = files.map{ |f| File.directory?(f) ? Dir[File.join(f, '**/*.rb')] : f }
        files = files.flatten.uniq
        files = files.map{ |f| File.expand_path(f) }
        files
      end

      #
      def default_tests
        if ENV['tests']
          ENV['tests'].split(/[:;]/)
        else
          DEFAULT_TESTS
        end
      end

      #
      #def ruby_command
      #  File.join(RbConfig::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      #end

    end

  end

end
