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
  def test_write_one
    fake_stack = Array.new.tap do |ary|
      ary << FakeLocation.new(absolute_path: "/path/a/b/c", label: "labc", lineno: 3)
      ary << FakeLocation.new(absolute_path: "/path/d/e/f", label: "lghi", lineno: 1)
      ary << FakeLocation.new(absolute_path: "/path/g/h/i", label: "ljkl", lineno: 7)
    end

    fmt = Logue::Format.new

    # content is matched in format_test
    
    out, err = capture_io do
      wr = Logue::Writer.new
      wr.write fmt, fake_stack, 1
    end
    refute_empty out
    puts "out: #{out}"
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
