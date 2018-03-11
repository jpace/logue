#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/frame'
require 'test_helper'
require 'paramesan'

module Logue
  class FrameTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ "/path/a/b/c.rb", "labc", 3 ],
      [ "/path/d/e/f.rb", "lghi", 1 ],
      [ "/path/g/h/i.rb", "ljkl", 7 ],
    ].each do |path, method, line|
      result = Frame.new path: path, method: method, line: line
      assert_equal Pathname.new(path),   result.path
      assert_equal method, result.method
      assert_equal line,   result.line
    end

    param_test [
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
    ].each do |exppath, expmethod, expline, str|
      result = Frame.new entry: str
      assert_equal Pathname.new(exppath),   result.path
      assert_equal expmethod, result.method
      assert_equal expline,   result.line
    end
  end
end
