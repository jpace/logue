#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/logger'
require 'test/unit'
require 'paramesan'

class Logue::LoggerTest < Test::Unit::TestCase
  include Paramesan

  def self.create_logger
    Logue::Logger.new
  end
  
  def test_default
    logger = self.class.create_logger

    assert_equal Logue::Level::FATAL, logger.level

    assert_equal $stdout,             logger.output
    assert_equal false,               logger.colorize_line

    assert_equal Hash.new,            logger.ignored_files
    assert_equal Hash.new,            logger.ignored_methods
    assert_equal Hash.new,            logger.ignored_classes

    assert_equal false,               logger.verbose
  end

  def test_respond_to
    logger = self.class.create_logger
    assert_equal true, logger.respond_to?(:blue)
    assert_equal false, logger.respond_to?(:no_such_color)
  end

  param_test [
    [ 1, 2, 3, 1, 2, 3 ],
  ].each do |expfile, expline, expfunction, *args|
    logger = self.class.create_logger
    logger.set_widths(*args)
    format = logger.format

    assert_equal expfile, format.file
    assert_equal expline, format.line
    assert_equal expfunction, format.function
  end

  param_test [
    [ 1, 2, 3, 1, 2, 3 ],
  ].each do |expfile, expline, expfunction, file, line, function|
    logger        = self.class.create_logger
    format        = Logue::LocationFormat.new file: file, line: line, function: function
    logger.format = format
    result        = logger.format

    assert_equal expfile, result.file
    assert_equal expline, result.line
    assert_equal expfunction, result.function
  end

  def test_trim
    logger = self.class.create_logger
    logger.trim = false
  end

  param_test [
    [ Logue::Level::WARN,  true ],  
    [ Logue::Level::DEBUG, false ], 
  ].each do |exp, quiet|
    logger = self.class.create_logger
    logger.quiet = quiet
    assert_equal exp, logger.level
  end

  param_test [
    [ true,  Logue::Level::ERROR ], 
    [ true,  Logue::Level::WARN ],  
    [ false, Logue::Level::INFO ],  
    [ true,  Logue::Level::WARN ],  
    [ false, Logue::Level::DEBUG ], 
  ].each do |exp, level|
    logger = self.class.create_logger
    logger.level = level
    assert_equal exp, logger.quiet
  end
end
