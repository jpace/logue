#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'logue/logger'

class LoggerTest < Test::Unit::TestCase
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
end
