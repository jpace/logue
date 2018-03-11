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

      first = result.frames.first

      assert_equal "stack_test.rb", first.path.basename.to_s
      assert_equal lnum + 1, first.line
      assert_equal "test_init", first.method

      second = result.frames[1]
      puts "second: #{second}"

      assert_equal "testcase.rb", second.path.basename.to_s
      assert_equal "run_test", second.method
    end
  end
end
