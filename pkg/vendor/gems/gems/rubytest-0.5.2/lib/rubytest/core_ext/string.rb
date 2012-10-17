class String

  # Preserves relative tabbing.
  # The first non-empty line ends up with n spaces before nonspace.
  #
  # This is a Ruby Facet (http://rubyworks.github.com/facets).

  def tabto(n)
    if self =~ /^( *)\S/
      indent(n - $1.length)
    else
      self
    end
  end unless method_defined?(:tabto)

  # Indent left or right by n spaces.
  # (This used to be called #tab and aliased as #indent.)
  #
  # This is a Ruby Facet (http://rubyworks.github.com/facets).

  def indent(n, c=' ')
    if n >= 0
      gsub(/^/, c * n)
    else
      gsub(/^#{Regexp.escape(c)}{0,#{-n}}/, "")
    end
  end unless method_defined?(:indent)

end

