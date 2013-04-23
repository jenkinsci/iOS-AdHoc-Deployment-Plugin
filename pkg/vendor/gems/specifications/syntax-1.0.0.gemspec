# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "syntax"
  s.version = "1.0.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Jamis Buck"]
  s.autorequire = "syntax"
  s.cert_chain = nil
  s.date = "2005-06-18"
  s.email = "jamis@jamisbuck.org"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = "1.8.15"
  s.summary = "Syntax is Ruby library for performing simple syntax highlighting."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
