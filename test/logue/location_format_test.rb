#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'
require 'test_helper'

class Logue::LocationFormatTestCase < Test::Unit::TestCase
  include Messager

  def test_default_values
    fmt = Logue::LocationFormat.new
    assert_equal Logue::LocationFormat::DEFAULT_FILENAME_WIDTH, fmt.file_width
    assert_equal Logue::LocationFormat::DEFAULT_LINENUM_WIDTH,  fmt.line_width
    assert_equal Logue::LocationFormat::DEFAULT_FUNCTION_WIDTH, fmt.method_width
    assert_equal true, fmt.trim
  end

  def assert_format expected, path, lineno, cls, func
    amsg   = message "path", path, "lineno", lineno, "cls", cls, "func", func
    fmt    = Logue::LocationFormat.new
    result = fmt.format path, lineno, cls, func
    assert_equal expected, result, amsg
  end

  def test_format
    path     = "/a/long/path/to/the/directory/abc.t"
    lineno   = 1    
    func     = "block (2 levels) in one"
    cls      = nil
    expected = "[.../the/directory/abc.t  :   1] {block (2 levels) in }"
    assert_format expected, path, lineno, cls, func
  end

  def test_init
    fmt = Logue::LocationFormat.new line_width: 7, file_width: 8, method_width: 11, trim: false
    assert_equal fmt.line_width,   7
    assert_equal fmt.file_width,   8
    assert_equal fmt.method_width, 11
    assert_equal fmt.trim,         false
  end

  def test_copy
    fmt  = Logue::LocationFormat.new line_width: 2
    copy = fmt.copy method_width: 123
    assert_equal copy.line_width,   2
    assert_equal copy.method_width, 123
  end

  def test_format_string
    exp    = "[%-25s:%4d] {%-20s}"
    fmt    = Logue::LocationFormat.new
    result = fmt.format_string
    assert_equal exp, result
  end
end
