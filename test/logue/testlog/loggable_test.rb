#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/log'
require 'logue/loggable'
require 'test_helper'
require 'logue/testlog/lgbl_testee'
require 'stringio'

module Logue
  class LoggableTestCase < Test::Unit::TestCase
    include Loggable

    def test_instance_colors
      Log.verbose = true
      io = StringIO.new
      Log.output = io
      Log.set_default_widths

      expected = Array.new
      expected << "[.../lgbl_testee.rb       :  10] {LgblTestee#crystal  } hello!\n"
      expected << "[.../lgbl_testee.rb       :  11] {LgblTestee#crystal  } [34mazul ... [0m\n"
      expected << "[.../lgbl_testee.rb       :  12] {LgblTestee#crystal  } [31mrojo?[0m\n"
      
      te = LgblTestee.new
      te.crystal

      # puts io.string

      assert_equal expected.join(''), io.string
    end
  end
end
