#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/logger'
require 'test/unit'
require 'paramesan'

class LoggerTest < Test::Unit::TestCase
  include Paramesan
  
  def test_default
    logger = Logue::Logger.new

    assert_equal Logue::Log::Severity::FATAL, logger.level

    assert_equal $stdout,                     logger.output
    assert_equal false,                       logger.colorize_line

    assert_equal Hash.new,                    logger.ignored_files
    assert_equal Hash.new,                    logger.ignored_methods
    assert_equal Hash.new,                    logger.ignored_classes

    assert_equal false,                       logger.verbose
  end

  def test_respond_to
    logger = Logue::Logger.new
    assert_equal true, logger.respond_to?(:blue)
  end

  param_test [
    [ 1, 2, 3, 1, 2, 3 ],
  ].each do |expfile, expline, expfunction, *args|
    logger = Logue::Logger.new
    logger.set_widths(*args)
    format = logger.format

    assert_equal expfile, format.file
    assert_equal expline, format.line
    assert_equal expfunction, format.function
  end

  param_test [
    [ 1, 2, 3, 1, 2, 3 ],
  ].each do |expfile, expline, expfunction, file, line, function|
    logger        = Logue::Logger.new
    format        = Logue::LocationFormat.new file: file, line: line, function: function
    logger.format = format
    result        = logger.format

    assert_equal expfile, result.file
    assert_equal expline, result.line
    assert_equal expfunction, result.function
  end

  def test_trim
    logger = Logue::Logger.new
    logger.trim = false
  end

  param_test [
    [ Logue::Log::Severity::WARN,  true ],  
    [ Logue::Log::Severity::DEBUG, false ], 
  ].each do |exp, quiet|
    logger = Logue::Logger.new
    logger.quiet = quiet
    assert_equal exp, logger.level
  end

  param_test [
    [ true,  Logue::Log::Severity::ERROR ], 
    [ true,  Logue::Log::Severity::WARN ],  
    [ false, Logue::Log::Severity::INFO ],  
    [ true,  Logue::Log::Severity::WARN ],  
    [ false, Logue::Log::Severity::DEBUG ], 
  ].each do |exp, level|
    logger = Logue::Logger.new
    logger.level = level
    assert_equal exp, logger.quiet
  end
end
