#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'logue/writer'
require 'logue/format'
require 'stringio'

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

class WriterTest < Test::Unit::TestCase
  def setup
    @stack = Array.new.tap do |ary|
      ary << FakeLocation.new(absolute_path: "/path/a/b/c", label: "labc", lineno: 3)
      ary << FakeLocation.new(absolute_path: "/path/d/e/f", label: "lghi", lineno: 1)
      ary << FakeLocation.new(absolute_path: "/path/g/h/i", label: "ljkl", lineno: 7)
    end
  end
  
  def test_write
    out, err = capture_io do
      wr = Logue::Writer.new Logue::Format.new
      wr.write @stack, 3
    end
    refute_empty out
    lines = out.lines
    assert_equal 3, lines.size
    assert_empty err
  end

  def test_write_frame
    out, err = capture_io do
      wr = Logue::Writer.new Logue::Format.new
      wr.write_frame @stack.first
    end
    refute_empty out
    assert_equal "[/path/a/b/c              :   3] {labc                }\n", out
    assert_empty err
  end

  def capture_io
    begin
      captured_stdout, captured_stderr = StringIO.new, StringIO.new

      orig_stdout, orig_stderr = $stdout, $stderr
      $stdout, $stderr         = captured_stdout, captured_stderr

      yield

      return captured_stdout.string, captured_stderr.string
    ensure
      $stdout = orig_stdout
      $stderr = orig_stderr
    end
  end

  def test_dump_collection
    ary = %w{ abc def ghi }

    #~~~ now write the collection, and test it ...
  end
end
