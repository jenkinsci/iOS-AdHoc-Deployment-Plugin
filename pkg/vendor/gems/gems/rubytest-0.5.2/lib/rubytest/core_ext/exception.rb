class Exception

  def set_assertion(boolean)
    @assertion = boolean
  end unless method_defined?(:set_assertion)

  def assertion?
    @assertion
  end unless method_defined?(:assertion?)

  def set_priority(integer)
    @priority = integer.to_i
  end unless method_defined?(:set_priority)

  def priority
    @priority ||= 0
  end unless method_defined?(:priority)

end
