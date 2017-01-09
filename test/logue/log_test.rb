#!/usr/bin/ruby -w
# -*- ruby -*-

require 'minitest/autorun'
require 'logue/log'

class LogTest < Minitest::Test
  def assert_accessor_methods rdmeth, *values
    wrmeth = (rdmeth.to_s + "=").to_sym
    logger = Logue::Log.logger
    values.each do |value|
      Logue::Log.send wrmeth, value
      
      assert_equal value, logger.send(rdmeth)
      assert_equal value, Logue::Log.send(rdmeth)
    end
  end
  
  def assert_read_method rdmeth, *values
    values.each do |value|
      Logue::Log.send rdmeth, *value
    end
  end
  
  def test_delegator_verbose
    assert_accessor_methods :verbose, false, true
  end

  def test_delegator_level
    assert_accessor_methods :level, Logue::Log::Severity::FATAL, Logue::Log::Severity::INFO
  end
  
  def test_delegator_quiet
    assert_accessor_methods :quiet, true, false
  end

  def test_delegator_format
    # no logger.format method yet:
    return if true
    assert_accessor_methods :format, "abc", "def"
  end
  
  def test_delegator_output
    assert_accessor_methods :output, "abc", "def"
  end
  
  def test_delegator_colorize_line
    assert_accessor_methods :colorize_line, false, true
  end

  def assert_outfile_equals value
    # is called, but converted from value to File.new(value)
    Logue::Log.outfile = value
  end
  
  def test_delegator_outfile
    assert_outfile_equals "/tmp/logue_test_abc"
  end

  def test_ignore_file
    assert_read_method :ignore_file, true, false
  end
    
  def test_ignore_method
    assert_read_method :ignore_method, true, false
  end
    
  def test_ignore_class
    assert_read_method :ignore_class, true, false
  end

  def test_log_file
    assert_read_method :log_file, true, false
  end
    
  def test_log_method
    assert_read_method :log_method, true, false
  end
    
  def test_log_class
    assert_read_method :log_class, true, false
  end
    
  def test_set_color
    lvl = Logue::Log::Severity::FATAL
    assert_read_method :set_color, [ lvl, :red ], [ lvl, :none ]
  end
end
