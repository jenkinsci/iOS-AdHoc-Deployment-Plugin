require 'rubygems'
require 'require_relative'
require 'test/unit'

require_relative '../lib/plist_generator.rb'

class PlistGeneratorTest<Test::Unit::TestCase
  def test_plist_generator
    filepath =  Manifest::create 'fooUrl','fooImagePath','fooBundleIdentifier','1.0','fooBar','/tmp/'
    assert_not_nil(filepath)
    assert(FileTest.exist? '/tmp/fooBar_1_0.plist')
    
    manifest = Plist::parse_xml "/tmp/fooBar_1_0.plist"
    
    app = manifest['items'][0]
    
    assert_equal app['assets'][0]['url'],'fooUrl'
    assert_equal app['assets'][1]['url'],'fooImagePath'
    assert_equal app['metadata']['bundle-identifier'],'fooBundleIdentifier'
    assert_equal app['metadata']['bundle-version'],'1.0'
    assert_equal app['metadata']['title'],'fooBar'
  end  
end
