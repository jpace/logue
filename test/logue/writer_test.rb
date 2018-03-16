#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/writer'
require 'logue/level'
require 'test_helper'
require 'stringio'

module Logue
  class WriterTest < Test::Unit::TestCase
    include Paramesan

    def test_init
      strio = StringIO.new
      writer = Writer.new output: strio
      writer.print "hdrabc", "msgdef", Level::DEBUG
      strio.close
      assert_equal "hdrabc msgdef\n", strio.string
    end

    param_test [
      [ "abc def", "abc", "def" ],
      [ "abc 123", "abc", "123" ],
      [ "ghi def", "ghi", "def" ],
    ].each do |exp, location, msg|
      writer = Writer.new
      line = writer.line location, msg, Level::DEBUG
      assert_equal exp, line
    end
  end
end
