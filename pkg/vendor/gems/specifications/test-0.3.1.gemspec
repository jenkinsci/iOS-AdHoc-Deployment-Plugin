# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "test"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Trans"]
  s.date = "2011-12-23"
  s.description = "Ruby Test is a universal test harness for Ruby. It can handle any compliant \ntest framework, even running tests from multiple frameworks in a single pass."
  s.email = "transfire@gmail.com"
  s.homepage = "http://rubyworks.githuib.com/rubytest"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Ruby Universal Test Harness"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubytest>, [">= 0"])
    else
      s.add_dependency(%q<rubytest>, [">= 0"])
    end
  else
    s.add_dependency(%q<rubytest>, [">= 0"])
  end
end
