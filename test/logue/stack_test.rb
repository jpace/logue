#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/stack'
require 'test/unit'
require 'pathname'

module Logue
  class StackTest < Test::Unit::TestCase
    def test_init
      lnum = __LINE__
      result = Stack.new

      x = result.frames[0]

      assert_equal "stack_test.rb", Pathname.new(x.path).basename.to_s
      assert_equal lnum + 1,        x.line
      assert_equal "test_init",     x.method

      y = result.frames[1]

      assert_equal "testcase.rb",   Pathname.new(y.path).basename.to_s
      assert_equal "run_test",      y.method
    end

    def second
      lnum = __LINE__
      result = Stack.new

      x = result.frames[0]
      assert_equal "stack_test.rb", Pathname.new(x.path).basename.to_s
      assert_equal lnum + 1,        x.line
      assert_equal "second",        x.method
      
      y = result.frames[1]

      assert_equal "(eval)", y.path
      assert_equal 2,        y.line
      assert_equal "first",  y.method
    end

    def test_from_eval
      instmeth = Array.new.tap do |a|
        a << 'def first'
        a << '  second'
        a << 'end'
      end
      instance_eval instmeth.join "\n"
      first
    end
  end
end
