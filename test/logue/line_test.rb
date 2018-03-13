#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/line'
require 'logue/location_format'
require 'logue/location'
require 'test_helper'
require 'paramesan'
require 'logue/io'

module Logue
  class LineTest < Test::Unit::TestCase
    include Paramesan
    include IOCapture
    
    class << self
      def frame path, label, lineno
        TestFrame.new path: path, label: label, lineno: lineno
      end
      
      def stack
        Array.new.tap do |ary|
          ary << frame("/path/a/b/c", "labc", 3)
          ary << frame("/path/d/e/f", "lghi", 1)
          ary << frame("/path/g/h/i", "ljkl", 7)
        end
      end
    end

    param_test [
      [ "[/path/a/b/c              :   3] {labc                } mabc", stack.first, nil, "mabc" ],
      [ "[/path/a/b/c              :   3] {cdef#labc           } mabc", stack.first, "cdef", "mabc" ]
    ].each do |exp, frame, cls, msg|
      loc = Location.new frame.path, frame.lineno, cls, frame.label
      line = Line.new loc, msg
      result = line.format LocationFormat.new
      assert_equal exp, result
    end
  end
end
