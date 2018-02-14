#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'
require 'test/unit'
require 'paramesan'

class Logue::PathUtilTestCase < Test::Unit::TestCase
  include Paramesan

  param_test [
    ["abcd",   "abcdef", 4 ],  
    ["abc",    "abcdef", 3 ],  
    ["abcdef", "abcdef", 10 ], 
    ["abcd",   "abcdef", -4 ], 
    ["abc",    "abcdef", -3 ], 
  ].each do |exp, str, len|
    trimmed = Logue::PathUtil.trim_left str, len
    assert_equal exp, trimmed
  end

  param_test [
    [ "ef.t",       "ab/cd/ef.t", 2 ],  
    [ "ab/cd/ef.t", "ab/cd/ef.t", 11 ], 
    [ "ab/cd/ef.t", "ab/cd/ef.t", 10 ], 
    [ ".../ef.t",   "ab/cd/ef.t", 9 ],  
    [ ".../ef.t",   "ab/cd/ef.t", 8 ],  
    [ "ef.t",       "ab/cd/ef.t", 7 ],  
    [ "ef.t",       "ab/cd/ef.t", 6 ],  
    [ "ef.t",       "ab/cd/ef.t", 5 ],  
    [ "ef.t",       "ab/cd/ef.t", 4 ],  
    [ "ef.t",       "ab/cd/ef.t", 3 ],  
    [ "ef.t",       "ab/cd/ef.t", 2 ],  
  ].each do |exp, str, len|
    trimmed = Logue::PathUtil.trim_right str, len
    assert_equal exp, trimmed
  end
end
