require 'logue/locations/location'
require 'logue/format/location_format'
require 'logue/locations/frame'
require 'logue/tc'

module Logue
  class LocationTest < TestCase
    def self.example_frame
      Frame.new path: "/path/a/b/c", method: "labc", line: 3      
    end
    
    param_test [
      [ "[/path/a/b/c              :   3] {labc                }", example_frame, nil ],
      [ "[/path/a/b/c              :   3] {cdef#labc           }", example_frame, "cdef" ]
    ].each do |exp, frame, cls|
      loc = Location.new frame.path, frame.line, cls, frame.method
      result = loc.format LocationFormat.new
      assert_equal exp, result
    end
  end
end
