#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'logue/line'
require 'logue/format'
require 'logue/location'
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

class LineTest < Test::Unit::TestCase
  include Paramesan
  include IOCapture
  
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
  
  # def test_write
  #   out, err = capture_io do
  #     wr = Logue::Line.new Logue::Format.new
  #     wr.write self.class.stack, 3
  #   end
  #   refute_empty out
  #   lines = out.lines
  #   assert_equal 3, lines.size
  #   assert_empty err
  # end

  param_test [
    [ "[/path/a/b/c              :   3] {labc                } mabc\n", stack.first, nil, "mabc" ],
    [ "[/path/a/b/c              :   3] {cdef#labc           } mabc\n", stack.first, "cdef", "mabc" ]
  ].each do |exp, frame, cls, msg|
    out, err = capture_io do
      loc = Logue::Location.new frame.absolute_path, frame.lineno, cls, frame.label
      wr = Logue::Line.new loc, msg
      wr.write Logue::Format.new
    end
    refute_empty out
    assert_equal exp, out
    assert_empty err
  end

  def test_dump_collection
    # ary = %w{ abc def ghi }

    #~~~ now write the collection, and test it ...
  end
end
