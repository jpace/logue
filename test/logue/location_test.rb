#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location'
require 'logue/location_format'
require 'test/unit'
require 'logue/io'
require 'paramesan'

class TestFrame
  attr_reader :absolute_path
  attr_reader :lineno
  attr_reader :label
  # attr_reader :base_label

  def initialize args
    @absolute_path = args[:absolute_path]
    @lineno        = args[:lineno]
    @label         = args[:label]
  end
end

class LocationTest < Test::Unit::TestCase
  include Paramesan
  
  class << self
    def frame path, label, lineno
      TestFrame.new absolute_path: path, label: label, lineno: lineno
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
    [ "[/path/a/b/c              :   3] {labc                }", stack.first, nil ],
    [ "[/path/a/b/c              :   3] {cdef#labc           }", stack.first, "cdef" ]
  ].each do |exp, frame, cls|
    loc = Logue::Location.new frame.absolute_path, frame.lineno, cls, frame.label
    result = loc.format Logue::LocationFormat.new
    assert_equal exp, result
  end
end
