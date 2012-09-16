# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')
require 'shoulda/rails'
# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

#class Test::Unit::TestCase
#  def teardown
#    Fixtures.all_loaded_fixtures.each do |table_name, fixtures|
#      klass = Module.const_get(table_name.to_s.classify)
#      klass.delete_all
#    end
#  end
#end
