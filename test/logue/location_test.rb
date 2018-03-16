#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location'
require 'logue/location_format'
require 'test_helper'
require 'logue/frame'

module Logue
  class LocationTest < Test::Unit::TestCase
    include Paramesan
    
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
