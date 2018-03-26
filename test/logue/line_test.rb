#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/line'
require 'logue/location_format'
require 'logue/location'
require 'test_helper'
require 'logue/frame'

module Logue
  class LineTest < Test::Unit::TestCase
    include Paramesan
    
    class << self
      def example_frame
        Frame.new path: "/path/a/b/c", method: "labc", line: 3
      end
    end

    param_test [
      [ "[/path/a/b/c              :   3] {labc                } mabc", example_frame, nil,    "mabc" ], 
      [ "[/path/a/b/c              :   3] {cdef#labc           } mabc", example_frame, "cdef", "mabc" ], 
    ].each do |exp, frame, cls, msg|
      loc    = Location.new frame.path, frame.line, cls, frame.method
      line   = Line.new loc, msg
      result = line.format LocationFormat.new
      assert_equal exp, result
    end
  end
end
