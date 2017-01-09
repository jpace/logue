#!/usr/bin/ruby -w
# -*- ruby -*-

require 'minitest/autorun'
require 'logue/writer'
require 'logue/format'

class FakeLocation
  attr_reader :absolute_path
  attr_reader :lineno
  attr_reader :label
  # attr_reader :base_label

  def initialize args
    @absolute_path = args[:absolute_path]
    @lineno = args[:lineno]
    @label = args[:label]
  end
end

class WriterTest < Minitest::Test
  def test_write_one
    fake_stack = Array.new.tap do |ary|
      ary << FakeLocation.new(absolute_path: "/a/long/path/to/the/directory/abc.t", label: "block (2 levels) in one", lineno: 1)
      ary << FakeLocation.new(absolute_path: "/another/path/def.t", label: "two", lineno: 11)
      ary << FakeLocation.new(absolute_path: "/a/whole/nother/path/ghi.t", label: "three", lineno: 101)
    end

    fmt = Logue::Format.new

    # content is matched in format_test
    
    out, err = capture_io do
      wr = Logue::Writer.new
      wr.write fmt, fake_stack, 1
    end
    refute_empty out
    assert_empty err
  end
end
