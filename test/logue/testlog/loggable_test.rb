#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'stringio'
require 'logue/log'
require 'logue/loggable'
require 'logue/testlog/lgbl_testee'

class LoggableTestCase < Test::Unit::TestCase
  include Logue::Loggable

  def test_instance_colors
    Logue::Log.verbose = true
    io = StringIO.new
    Logue::Log.output = io

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
