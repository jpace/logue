#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'
require 'test/unit'
require 'paramesan'

module Logue
  class PathUtilTestCase < Test::Unit::TestCase
    include Paramesan

    param_test [
      ["abcd",    4 ],
      ["abc",     3 ],
      ["abcdef", 10 ],
      ["abcdef",  6 ],
      ["abcde",   5 ],
      ["abcd",   -4 ],
      ["abc",    -3 ],
    ].each do |exp, len|
      trimmed = PathUtil.trim_left "abcdef", len
      assert_equal exp, trimmed
    end

    param_test [
      [ "ab/cd/ef.t", 11 ],
      [ "ab/cd/ef.t", 10 ],
      [ ".../ef.t",    9 ],
      [ ".../ef.t",    8 ],
      [ "ef.t",        7 ],
      [ "ef.t",        6 ],
      [ "ef.t",        5 ],
      [ "ef.t",        4 ],
      [ "ef.t",        3 ],
      [ "ef.t",        2 ],
    ].each do |exp, len|
      trimmed = PathUtil.trim_right "ab/cd/ef.t", len
      assert_equal exp, trimmed
    end
  end
end
