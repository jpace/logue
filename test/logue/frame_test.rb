#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/frame'
require 'logue/location_format'
require 'test_helper'
require 'paramesan'

module Logue
  class FrameTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ "/path/a/b/c.rb", "labc", 3 ], 
      [ "/path/d/e/f.rb", "lghi", 1 ], 
      [ "/path/g/h/i.rb", "ljkl", 7 ], 
      [ "(eval)",         "labc", 3 ], 
    ].each do |path, method, line|
      result = Frame.new path: path, method: method, line: line
      assert_equal path,   result.path
      assert_equal method, result.method
      assert_equal line,   result.line
    end

    param_test [
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
    ].each do |exppath, expmethod, expline, str|
      result = Frame.new entry: str
      assert_equal exppath,   result.path
      assert_equal expmethod, result.method
      assert_equal expline,   result.line
    end

    param_test [
      [ "[/path/a/b/c.rb           :   3] {cabc#labc           }", "/path/a/b/c.rb", "labc", 3 ], 
      [ "[(eval)                   :   3] {cabc#labc           }", "(eval)",         "labc", 3 ], 
    ].each do |exp, path, method, line|
      fmt    = LocationFormat.new
      frame  = Frame.new path: path, method: method, line: line
      result = frame.formatted fmt, "cabc"
      assert_equal exp, result
    end
  end
end
