#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/writer'
require 'logue/level'
require 'logue/tc'
require 'stringio'

module Logue
  class WriterTest < TestCase
    def test_init
      strio = StringIO.new
      writer = Writer.new output: strio
      # I think assert_same should compare by ID, not #equal?
      assert_equal strio.object_id,     writer.output.object_id
      assert_equal Array.new, writer.colors
      assert_equal false,     writer.colorize_line
      strio.close
    end

    def test_print
      strio = StringIO.new
      writer = Writer.new output: strio
      writer.print "hdrabc msgdef\n", Level::DEBUG
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
