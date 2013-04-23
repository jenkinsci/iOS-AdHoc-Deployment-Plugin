class Assertion < Exception

  # New assertion (failure).
  #
  # @param message [String] the failure message
  # @param options [Hash] options such as :backtrace
  #
  def initialize(message=nil, options={})
    super(message)
    backtrace = options[:backtrace]
    set_backtrace(backtrace) if backtrace
    @assertion = true
  end

  # Technically any object that affirmatively responds to #assertion?
  # can be taken to be an Assertion. This makes it easier for various 
  # libraries to work together without having to depend upon a common
  # Assertion base class.
  def assertion?
    true # @assertion
  end

  # Parents error message prefixed with "(assertion)".
  #
  # @return [String] error message
  def to_s
    '(assertion) ' + super
  end

end
