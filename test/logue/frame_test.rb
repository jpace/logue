#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/frame'
require 'test/unit'
require 'paramesan'

module Logue
  class FrameTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ "/path/a/b/c.rb", "labc", 3 ],
      [ "/path/d/e/f.rb", "lghi", 1 ],
      [ "/path/g/h/i.rb", "ljkl", 7 ],
    ].each do |path, function, line|
      result = Frame.new absolute_path: path, function: function, line: line
      assert_equal path,     result.absolute_path
      assert_equal function, result.function
      assert_equal line,     result.line
    end

    param_test [
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
      [ "/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'" ],
    ].each do |exppath, expfunction, expline, str|
      result = Frame.new entry: str
      assert_equal exppath,     result.absolute_path
      assert_equal expfunction, result.function
      assert_equal expline,     result.line
    end
  end
end
