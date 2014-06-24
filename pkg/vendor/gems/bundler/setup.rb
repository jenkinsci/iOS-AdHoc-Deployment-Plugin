require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
ruby_version = RbConfig::CONFIG["ruby_version"]
path = File.expand_path('..', __FILE__)
$:.unshift File.expand_path("#{path}/../gems/CFPropertyList-2.2.0/lib")
$:.unshift File.expand_path("#{path}/../gems/ansi-1.4.3/lib")
$:.unshift File.expand_path("#{path}/../gems/bouncy-castle-java-1.5.0147/lib")
$:.unshift File.expand_path("#{path}/../gems/ftpfxp-0.0.4/lib")
$:.unshift File.expand_path("#{path}/../gems/i18n-0.6.1/lib")
$:.unshift File.expand_path("#{path}/../gems/json-1.7.5-java/lib")
$:.unshift File.expand_path("#{path}/../gems/slop-3.0.4/lib")
$:.unshift File.expand_path("#{path}/../gems/jenkins-plugin-runtime-0.2.2/lib")
$:.unshift File.expand_path("#{path}/../gems/jruby-openssl-0.9.4/lib")
$:.unshift File.expand_path("#{path}/../gems/mime-types-1.19/lib")
$:.unshift File.expand_path("#{path}/../gems/polyglot-0.3.3/lib")
$:.unshift File.expand_path("#{path}/../gems/treetop-1.4.12/lib")
$:.unshift File.expand_path("#{path}/../gems/mail-2.5.3/lib")
$:.unshift File.expand_path("#{path}/../gems/syntax-1.0.0/lib")
$:.unshift File.expand_path("#{path}/../gems/maruku-0.6.1/lib")
$:.unshift File.expand_path("#{path}/../gems/plist-3.1.0/lib")
$:.unshift File.expand_path("#{path}/../gems/pony-1.4/lib")
$:.unshift File.expand_path("#{path}/../gems/require_relative-1.0.3/lib")
$:.unshift File.expand_path("#{path}/../gems/rubytest-0.5.2/lib")
$:.unshift File.expand_path("#{path}/../gems/rubyzip-0.9.9/lib")
$:.unshift File.expand_path("#{path}/../gems/test-0.3.1/lib")
