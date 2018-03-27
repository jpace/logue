#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'logue/testlog/logtestee'
require 'logue/location_format'
require 'test_helper'
require 'stringio'

module Logue
  class LogTestCase < Test::Unit::TestCase
    include Loggable
    include Paramesan

    def run_log_testee_test methname, expected, &blk
      Log.verbose = true
      io = StringIO.new
      Log.output = io
      Log.set_default_widths

      blk.call if blk

      lt = LogTestee.new
      lt.send methname

      str = io.string

      lines = str.split "\n"

      (0 ... expected.size).each do |idx|
        if expected[idx]
          assert_equal expected[idx], lines[idx], "index: #{idx}"
        end
      end
      
      Log.set_default_widths
    end

    def run_format_test expected, &blk
      Log.verbose = true
      io = StringIO.new
      Log.output = io
      Log.set_default_widths

      blk.call

      lt = LogTestee.new
      lt.format_test

      assert_equal expected.join(''), io.string
      
      Log.set_default_widths
    end

    def test_no_output
      run_log_testee_test(:log_all, Array.new) do
        Log.verbose = false
      end
    end

    def test_output_arg
      methname = "log_all"

      expected = Array.new
      (1 .. 6).each do |lnum|
        msg = "hello, world?"
        if lnum == 4 || lnum == 5
          msg = "EXPECTED OUTPUT TO STDERR: hello, world."
        end
        expected << sprintf("[.../testlog/logtestee.rb :  %2d] {%-20s} %s", 16 + lnum, methname[0 .. 19], msg)
      end

      run_log_testee_test(:log_all, expected)
    end

    def test_output_block_at_level
      Log.level = Level::DEBUG
      
      methname = "log_block"

      msg = "block party"

      expected = Array.new
      expected << sprintf("[.../testlog/logtestee.rb :  %2d] {%-20s} %s", 26, methname[0 .. 19], msg)

      run_log_testee_test(:log_block, expected)
    end

    def test_output_block_below_level
      expected = Array.new

      run_log_testee_test(:log_block, expected) do
        Log.level = Level::INFO
      end
    end

    def test_colors_foreground
      methname = "log_foregrounds"
      expected = Array.new
      expected << sprintf("[.../testlog/logtestee.rb :  %2d] {%-20s} %s", 30, methname[0 .. 19], "\e[37mwhite wedding\e[0m")
      expected << sprintf("[.../testlog/logtestee.rb :  %2d] {%-20s} %s", 31, methname[0 .. 19], "\e[34mblue iris\e[0m")
      
      run_log_testee_test(:log_foregrounds, expected)
    end

    def xxxtest_colors_background
      expected = Array.new
      expected << "[.../test/logue/log_test.rb: 109] {LogTestCase#test_col} \e[46mred\e[0m"

      run_log_testee_test(:log_foregrounds, expected) do
      end
    end

    def widths file: LocationFormat::Defaults::FILENAME, line: LocationFormat::Defaults::LINE, method: LocationFormat::Defaults::METHOD
      Log.set_widths file, line, method
    end

    param_test [
      [ "[.../testlog/logtestee.rb :  10] {format_test         } tamrof\n",                { } ],            
      [ "[.../test/logue/testlog/logtestee.rb:  10] {format_test         } tamrof\n",      { file: -35 } ],  
      [ "[.../testlog/logtestee.rb :10        ] {format_test         } tamrof\n",          { line: -10 } ],  
      [ "[.../testlog/logtestee.rb :  10] {                        format_test} tamrof\n", { method: 35 } ], 
      [ "[.../testlog/logtestee.rb :00000010] {format_test         } tamrof\n",            { line: "08" } ]
    ] do |expline, widthargs|
      Log.set_default_widths
      run_format_test Array[expline] do
        widths widthargs
      end
      Log.set_default_widths
    end

    def test_respond_to_color
      assert Log.respond_to? :blue
    end
  end
end
