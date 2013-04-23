module Test

  # The Advice class is an observer that can be customized to 
  # initiate before, after and upon procedures for all of RubyTests
  # observable points.
  #
  # Only one procedure is allowed per-point.
  #
  class Advice

    #
    def self.joinpoints
      @joinpoints ||= []
    end

    # TODO: Should before and affter hooks be evaluated in the context of test
    #       object scope? The #scope field has been added to the RubyTest spec
    #       just in case.

    #
    def self.joinpoint(name)
      joinpoints << name.to_sym

      class_eval %{
        def #{name}(*args)
          procedure = @table[:#{name}]
          procedure.call(*args) if procedure
        end
      }
    end

    #
    def initialize
      @table = {}
    end

    # @method begin_suite(suite)
    joinpoint :begin_suite

    # @method begin_case(case)
    joinpoint :begin_case

    # @method skip_test(test, reason)
    joinpoint :skip_test

    # @method begin_test(test)
    joinpoint :begin_test

    # @method pass(test)
    joinpoint :pass

    # @method fail(test, exception)
    joinpoint :fail

    # @method error(test, exception)
    joinpoint :error

    # @method todo(test, exception)
    joinpoint :todo

    # @method end_test(test)
    joinpoint :end_test

    # @method end_case(case)
    joinpoint :end_case

    # @method end_suite(suite)
    joinpoint :end_suite

    #
    #def [](key)
    #  @table[key.to_sym]
    #end

    # Add a procedure to one of the join-points.
    def join(type, &block)
      type = valid_type(type) 
      @table[type] = block
    end

    # Add a procedure to one of the before join-points.
    def join_before(type, &block)
      join("begin_#{type}", &block) 
    end

    # Add a procedure to one of the after join-points.
    def join_after(type, &block)
      join("end_#{type}", &block)
    end

    # Ignore any other signals (precautionary).
    def method_missing(*)
    end

  private

    #def invoke(symbol, *args)
    #  if @table.key?(symbol)
    #    self[symbol].call(*args)
    #  end
    #end

    #
    def valid_type(type)
      type = message_type(type)
      unless self.class.joinpoints.include?(type)
        raise ArgumentError, "not a valid advice type -- #{type}"
      end
      type
    end

    #
    def message_type(type)
      type = type.to_sym
      case type
      when :each
        type = :test
      when :all
        type = :case
      when :begin_each
        type = :begin_test
      when :begin_all
        type = :begin_case
      when :end_each
        type = :end_test
      when :end_all
        type = :end_case
      end
      return type
    end

  end

end
