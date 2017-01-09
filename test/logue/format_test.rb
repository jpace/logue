#!/usr/bin/ruby -w
# -*- ruby -*-

require 'minitest/autorun'
require 'logue/format'

class Logue::FormatTestCase < Minitest::Test
  # use as:
  # msg "path", path, "lineno", lineno, "cls", cls, "func", func
  def message(*fields)
    fields.each_slice(2).collect do |field, value|
      "#{field}: #{value}"
    end.join "; "
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
end
