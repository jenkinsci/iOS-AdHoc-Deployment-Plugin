# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubytest"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["trans"]
  s.date = "2012-07-20"
  s.description = "Ruby Test is a universal test harness for Ruby. It can handle any compliant \ntest framework, even running tests from multiple frameworks in a single pass."
  s.email = ["transfire@gmail.com"]
  s.executables = ["ruby-test", "rubytest"]
  s.extra_rdoc_files = ["LICENSE.txt", "HISTORY.md", "README.md"]
  s.files = ["bin/ruby-test", "bin/rubytest", "LICENSE.txt", "HISTORY.md", "README.md"]
  s.homepage = "http://rubyworks.github.com/rubytest"
  s.licenses = ["BSD-2-Clause"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby Universal Test Harness"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ansi>, [">= 0"])
      s.add_development_dependency(%q<detroit>, [">= 0"])
      s.add_development_dependency(%q<qed>, [">= 0"])
    else
      s.add_dependency(%q<ansi>, [">= 0"])
      s.add_dependency(%q<detroit>, [">= 0"])
      s.add_dependency(%q<qed>, [">= 0"])
    end
  else
    s.add_dependency(%q<ansi>, [">= 0"])
    s.add_dependency(%q<detroit>, [">= 0"])
    s.add_dependency(%q<qed>, [">= 0"])
  end
end
