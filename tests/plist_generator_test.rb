require 'rubygems'
require 'require_relative'
require 'test/unit'

require_relative '../lib/plist_generator.rb'

class PlistGeneratorTest<Test::Unit::TestCase
  def test_plist_generator
    filepath = Manifest::create 'fooUrl','fooImagePath','fooBundleIdentifier','1.0','fooBar','ManifestTemplate.plist','/tmp/'
    assert FileTest.exist? '/tmp/fooBar_1_0.plist', "Failed to create file"
    
  end  
end
