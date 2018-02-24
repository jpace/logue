#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/log'
require 'test/unit'
require 'paramesan'

class Logue::LogTest < Test::Unit::TestCase
  include Paramesan

  param_test [
    [ :verbose,       false,                       true ],                       
    [ :level,         Logue::Log::Severity::FATAL, Logue::Log::Severity::INFO ], 
    [ :output,        "abc",                       "def" ],
    [ :colorize_line, false,                       true ],                       
  ].each do |methname, *values|
    wrmeth = (methname.to_s + "=").to_sym
    logger = Logue::Log.logger
    values.each do |value|
      Logue::Log.send wrmeth, value
      
      assert_equal value, logger.send(methname)
      assert_equal value, Logue::Log.send(methname)
    end
  end
  
  def test_delegator_outfile
    # is called, but converted from value to File.new(value)
    Logue::Log.outfile = "/tmp/logue_test_abc"
  end

  param_test [
    [ :ignore_file,   true, false ], 
    [ :ignore_method, true, false ], 
    [ :ignore_class,  true, false ], 
    [ :log_file,      true, false ], 
    [ :log_method,    true, false ], 
    [ :log_class,     true, false ],
    [ :set_color, [ Logue::Log::Severity::FATAL, :red ], [ Logue::Log::Severity::FATAL, :none ] ],
  ].each do |methname, *values|
    values.each do |value|
      Logue::Log.send methname, *value
    end
  end  
end
