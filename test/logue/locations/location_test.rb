require 'logue/locations/location'
require 'logue/format/location_format'
require 'logue/locations/frame'
require 'logue/tc'

module Logue
  class LocationTest < TestCase
    def test_init
      obj = Location.new '/path/a/b/c', 3, "ClassAbc", "meth_ghi"
      assert_all [
                   lambda { assert_equal '/path/a/b/c', obj.path },
                   lambda { assert_equal 3, obj.line },
                   lambda { assert_equal 'ClassAbc', obj.cls },
                   lambda { assert_equal 'meth_ghi', obj.method }
                 ]
    end
  end
end
