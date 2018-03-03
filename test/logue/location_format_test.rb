#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'
require 'test_helper'

module Logue
  class LocationFormatWidthsTestCase < Test::Unit::TestCase
    include Messager

    def test_default_values
      widths = LocationFormatWidths.new
      assert_equal LocationFormatWidths::DEFAULT_FILENAME, widths.filename
      assert_equal LocationFormatWidths::DEFAULT_LINE,     widths.line
      assert_equal LocationFormatWidths::DEFAULT_FUNCTION, widths.function
    end

    def test_equal
      x = LocationFormatWidths.new
      y = LocationFormatWidths.new filename: 3
      assert_false x == y
    end
  end
  
  class LocationFormatTestCase < Test::Unit::TestCase
    include Messager

    def test_default_values
      fmt = LocationFormat.new
      assert_equal LocationFormatWidths::DEFAULT_FILENAME, fmt.file
      assert_equal LocationFormatWidths::DEFAULT_LINE,     fmt.line
      assert_equal LocationFormatWidths::DEFAULT_FUNCTION, fmt.function
      assert_equal true,                                          fmt.trim
    end

    def assert_format expected, path, line, cls, func
      amsg   = message "path", path, "line", line, "cls", cls, "func", func
      fmt    = LocationFormat.new
      result = fmt.format path, line, cls, func
      assert_equal expected, result, amsg
    end

    def test_format
      path     = "/a/long/path/to/the/directory/abc.t"
      line     = 1    
      func     = "block (2 levels) in one"
      cls      = nil
      expected = "[.../the/directory/abc.t  :   1] {block (2 levels) in }"
      assert_format expected, path, line, cls, func
    end

    def test_init
      fmt = LocationFormat.new line: 7, file: 8, function: 11, trim: false
      assert_equal fmt.line,     7
      assert_equal fmt.file,     8
      assert_equal fmt.function, 11
      assert_equal fmt.trim,     false
    end

    def test_copy
      fmt  = LocationFormat.new line: 2
      copy = fmt.copy function: 123
      assert_equal copy.line,     2
      assert_equal copy.function, 123
    end

    def test_format_string
      exp    = "[%-25s:%4d] {%-20s}"
      fmt    = LocationFormat.new
      result = fmt.format_string
      assert_equal exp, result
    end
  end
end
