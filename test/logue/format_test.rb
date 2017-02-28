#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'logue/format'

class Logue::FormatTestCase < Test::Unit::TestCase
  # use as:
  # msg "path", path, "lineno", lineno, "cls", cls, "func", func
  def message(*fields)
    fields.each_slice(2).collect do |field, value|
      "#{field}: #{value}"
    end.join "; "
  end

  def assert_instance_variable expected, obj, name
    val = obj.instance_eval name
    assert_equal expected, val, "name: #{name}; expected: #{expected}; result: #{val}"
    val
  end

  def test_default_values
    fmt = Logue::Format.new
    assert_instance_variable Logue::FormatWidths::DEFAULT_FILENAME, fmt, "@file_width"
    assert_instance_variable Logue::FormatWidths::DEFAULT_LINENUM, fmt, "@line_width"
    assert_instance_variable Logue::FormatWidths::DEFAULT_FUNCTION, fmt, "@method_width"
    assert_instance_variable true, fmt, "@trim"
  end

  def assert_format expected, path, lineno, cls, func
    msg = message "path", path, "lineno", lineno, "cls", cls, "func", func
    fmt = Logue::Format.new
    fmt.format path, lineno, cls, func
    result = fmt.format path, lineno, cls, func
    assert_equal expected, result, msg
  end

  def test_write
    path = "/a/long/path/to/the/directory/abc.t"
    lineno = 1    
    func = "block (2 levels) in one"
    cls = nil
    expected = "[.../the/directory/abc.t  :   1] {block (2 levels) in }"
    assert_format expected, path, lineno, cls, func
  end

  def test_copy
    fmt = Logue::Format.new line_width: 77
    val = fmt.instance_eval "@line_width"
    assert_equal 77, val
    
    copy = fmt.copy method_width: 123
    val = copy.instance_eval "@line_width"
    assert_equal 77, val
    
    val = copy.instance_eval "@method_width"
    assert_equal 123, val
  end
end
