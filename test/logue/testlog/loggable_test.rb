#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/log'
require 'logue/loggable'
require 'test_helper'
require 'logue/testlog/lgbl_testee'
require 'stringio'

module Logue
  class LoggableTestCase < Test::Unit::TestCase
    def test_instance_colors
      Log.verbose = true
      io = StringIO.new
      Log.output = io
      Log.set_default_widths

      expected = Array.new
      expected << "[.../lgbl_testee.rb       :  14] {LgblTestee#crystal  } hello!\n"
      expected << "[.../lgbl_testee.rb       :  15] {LgblTestee#crystal  } [34mazul ... [0m\n"
      expected << "[.../lgbl_testee.rb       :  16] {LgblTestee#crystal  } [31mrojo?[0m\n"
      
      te = LgblTestee.new
      te.crystal

      assert_equal expected.join(''), io.string
    end
  end
end
