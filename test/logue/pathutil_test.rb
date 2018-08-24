#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'
require 'test_helper'

module Logue
  class PathUtilTestCase < Test::Unit::TestCase
    include Paramesan

    param_test [
      ["abcd",    4 ],
      ["abc",     3 ],
      ["abcdef", 10 ],
      ["abcdef",  6 ],
      ["abcde",   5 ],
      ["",        0 ],
      ["",       -4 ],
    ] do |exp, len|
      result = PathUtil.trim_left "abcdef", len
      assert_equal exp, result
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
      [ "",           -2 ],
    ] do |exp, len|
      result = PathUtil.trim_right "ab/cd/ef.t", len
      assert_equal exp, result
    end
  end
end
