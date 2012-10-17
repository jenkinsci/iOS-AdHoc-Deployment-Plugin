# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "require_relative"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Klabnik", "Brendan Taylor"]
  s.date = "2011-10-22"
  s.description = "In Ruby 1.9.2, \".\" was removed from $:. This is a good idea, for security reasons. This gem backports this to Ruby 1.8."
  s.email = ["steve@steveklabnik.com", "whateley@gmail.com"]
  s.homepage = "http://steveklabnik.github.com/require_relative"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "This backports require_relative to Ruby 1.8."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rocco>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rocco>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rocco>, [">= 0"])
  end
end
