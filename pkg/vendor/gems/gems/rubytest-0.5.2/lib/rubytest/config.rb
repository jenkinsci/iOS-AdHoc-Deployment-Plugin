module Test

  #
  def self.run(name=nil, &block)
    name = name ? name : 'default'

    @config ||= {}
    @config[name.to_s] = block
  end

  #
  def self.config
    @config ||= {}
  end

  # Handle test run configruation.
  #
  # @todo Why not use the instace level for `Test.config` ?
  #
  class Config

    # Tradional test configuration file glob. This glob looks for a `Testfile`
    # or a `.test` file, either of which can have an optional `.rb` extension.
    # Also `config/rubytest.rb` is permissable.
    GLOB_RC = '{testfile.rb,testfile,.test.rb,.test,config/rubytest.rb,.config/rubytest.rb}'

    # Glob used to find project root directory.
    GLOB_ROOT = '{.ruby,.git,.hg,_darcs,lib/}'

    #
    # Load configuration. This will first look for a root level `Testfile.rb`
    # or `.test.rb` file. Failing that it will look for `task/*.rubytest` files.
    # An example entry into any of these look like:
    #
    #   Test.run :name do |run|
    #     run.files << 'test/case_*.rb'
    #   end
    #
    # Use `default` for name for non-specific profile and `common` for code that
    # should apply to all configurations.
    #
    # Failing any traditional configuration files, the Confection system will
    # be used. An example entry in a projects `Config.rb` is:
    #
    #   config 'rubytest', profile: 'name' do |run|
    #     run.files << 'test/case_*.rb'
    #   end
    #
    # You can leave the `:name` parameter out for `:default`.
    #
    def self.load
      if rc_file
        super(rc_file)
      #else
      #  if config = Test.rc_config
      #    config.each do |c|
      #      Test.run(c.profile, &c)
      #    end
      #  end
      end
    end

    # Find traditional rc file.
    def self.rc_file
      @rc_file ||= (
        Dir.glob(File.join(root, GLOB_RC), File::FNM_CASEFOLD).first
      )
    end

    # Find and cache project root directory.
    #
    # @return [String] Project's root path.
    def self.root
      @root ||= (
        glob    = GLOB_ROOT
        stop    = '/'
        default = Dir.pwd
        dir     = Dir.pwd
        until dir == stop
          break dir if Dir[File.join(dir, glob)].first
          dir = File.dirname(dir)
        end
        dir == stop ? default : dir
      )
    end

    # Load and cache a project's `.ruby` file.
    #
    # @return [Hash] Project's loaded `.ruby` file, if it has one.
    def self.dotruby
      @dotruby ||= (
        drfile = File.join(root, '.ruby')
        if File.exist?(drfile)
          YAML.load_file(drfile)
        else
          {}
        end
      )
    end

    # Setup $LOAD_PATH based on .ruby file.
    #
    # @todo Maybe we should not fallback to typical load path?
    def self.load_path_setup
      if load_paths = dotruby['load_path']
        load_paths.each do |path|
          $LOAD_PATH.unshift(File.join(root, path))
        end
      else
        typical_load_path = File.join(root, 'lib')
        if File.directory?(typical_load_path)
          $LOAD_PATH.unshift(typical_load_path) 
        end
      end
    end

  end

end
