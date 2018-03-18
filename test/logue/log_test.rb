#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/log'
require 'test_helper'

module Logue
  class LogTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ :verbose,       false,        true ],        
      [ :level,         Level::FATAL, Level::INFO ], 
      [ :colorize_line, false,        true ],        
    ].each do |methname, *values|
      wrmeth = (methname.to_s + "=").to_sym
      logger = Log.logger
      values.each do |value|
        Log.send wrmeth, value
        
        assert_equal value, logger.send(methname)
        assert_equal value, Log.send(methname)
      end
    end
    
    def test_delegator_outfile
      # is called, but converted from value to File.new(value)
      Log.outfile = "/tmp/logue_test_abc"
    end

    param_test [
      [ :ignore_file,   true, false ], 
      [ :ignore_method, true, false ], 
      [ :ignore_class,  true, false ], 
      [ :log_file,      true, false ], 
      [ :log_method,    true, false ], 
      [ :log_class,     true, false ],
      [ :set_color, [ Level::FATAL, :red ], [ Level::FATAL, :none ] ],
    ].each do |methname, *values|
      values.each do |value|
        Log.send methname, *value
      end
    end

    def test_red
      Log.red "mabc", Level::WARN, "cdef"
    end

    def test_yellow
      Log.yellow "mabc", Level::WARN, "cdef"
    end
  end
end
