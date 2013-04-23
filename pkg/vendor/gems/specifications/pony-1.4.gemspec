# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pony"
  s.version = "1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Wiggins", "maint: Ben Prew"]
  s.date = "2011-11-29"
  s.description = "Send email in one command: Pony.mail(:to => 'someone@example.com', :body => 'hello')"
  s.email = "ben.prew@gmail.com"
  s.homepage = "http://github.com/benprew/pony"
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "pony"
  s.rubygems_version = "1.8.15"
  s.summary = "Send email in one command: Pony.mail(:to => 'someone@example.com', :body => 'hello')"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mail>, ["> 2.0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
    else
      s.add_dependency(%q<mail>, ["> 2.0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<mail>, ["> 2.0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
  end
end
