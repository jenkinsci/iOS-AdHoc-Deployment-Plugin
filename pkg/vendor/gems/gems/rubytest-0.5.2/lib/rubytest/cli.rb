module Test

  # Command line interface to test runner.
  #
  class CLI

    #
    # Convenience method for invoking the CLI.
    #
    def self.run(*argv)
      new.run(*argv)
    end

    #
    # Initialize CLI instance.
    #
    def initialize
      require 'optparse'

      Test::Config.load

      @profile = ENV['profile'] || ENV['p'] || 'default'
      @config  = Test.config
      @runner  = Runner.new
    end

    #
    # @return [Runner]
    #
    attr :runner

    #
    # @return [Hash]
    #
    attr :config

    #
    attr_accessor :profile

    #
    # Run tests.
    #
    def run(*argv)
      options.parse!(argv)

      run_profile

      runner.files.replace(argv) unless argv.empty?

      Test::Config.load_path_setup  #unless runner.autopath == false

      begin
        success = runner.run
        exit -1 unless success
      rescue => error
        raise error if $DEBUG
        $stderr.puts('ERROR: ' + error.to_s)
      end
    end

    #
    # Run the common profile if defined and then the specific
    # profile.
    #
    def run_profile
      raise "no such profile -- #{profile}" unless config[profile] or profile == 'default'

      common  = config['common']
      common.call(runner) if common

      profig = config[profile]
      profig.call(runner) if profig
    end

    #
    # Setup OptionsParser instance.
    #
    def options
      this = self

      OptionParser.new do |opt|
        opt.banner = "Usage: #{$0} [options] [files ...]"

        opt.separator "PRESET OPTIONS:"

        opt.on '-p', '--profile NAME', "use configuration profile" do |name|
          this.profile = name.to_s
        end

        config_names = config.keys - ['common', 'default']

        unless config_names.empty?
          config_names.each do |name|
            opt.separator((" " * 40) + "* #{name}")
          end
        end

        opt.separator "CONFIG OPTIONS:"
        opt.on '-f', '--format NAME', 'report format' do |name|
          runner.format = name
        end
        opt.on '-y', '--tapy', 'shortcut for -f tapy' do
          runner.format = 'tapy'
        end
        opt.on '-j', '--tapj', 'shortcut for -f tapj' do
          runner.format = 'tapj'
        end

        opt.on '-t', '--tag TAG', 'select tests by tag' do |tag|
          runner.tags << tag
        end
        opt.on '-u', '--unit TAG', 'select tests by software unit' do |unit|
          runner.units << unit
        end
        opt.on '-m', '--match TEXT', 'select tests by description' do |text|
          runner.match << text 
        end

        opt.on '-I', '--loadpath PATH',  'add to $LOAD_PATH' do |paths|
          paths.split(/[:;]/).reverse_each do |path|
            $LOAD_PATH.unshift path
          end
        end
        opt.on '-r', '--require FILE', 'require file' do |file|
          require file
        end
        opt.on '-v' , '--verbose', 'provide extra detailed report' do
          runner.verbose = true
        end
        #opt.on('--log DIRECTORY', 'log directory'){ |dir|
        #  options[:log] = dir
        #}
        opt.on("--[no-]ansi" , 'turn on/off ANSI colors'){ |v| $ansi = v }
        opt.on("--debug" , 'turn on debugging mode'){ $DEBUG = true }

        opt.separator "COMMAND OPTIONS:"
        #opt.on("--about" , 'display information about rubytest'){
        #  puts "Ruby Test v#{VERSION}"
        #  puts "#{COPYRIGHT}"
        #  exit
        #}
        opt.on('-h', '--help', 'display this help message'){
          puts opt
          exit
        }
      end
    end

  end

end
