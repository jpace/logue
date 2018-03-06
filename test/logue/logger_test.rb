#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/logger'
require 'test/unit'
require 'paramesan'

module Logue
  class LoggerTest < Test::Unit::TestCase
    include Paramesan

    def self.create_logger
      Logger.new
    end
    
    def test_default
      logger = self.class.create_logger

      assert_equal Level::FATAL, logger.level

      assert_equal $stdout,      logger.output
      assert_equal false,        logger.colorize_line

      assert_equal Filter.new,   logger.filter

      assert_equal false,        logger.verbose
    end

    def test_respond_to
      logger = self.class.create_logger
      assert_equal true,  logger.respond_to?(:blue)
      assert_equal false, logger.respond_to?(:no_such_color)
    end

    param_test [
      [ 1, 2, 3, 1, 2, 3 ],
    ].each do |expfile, expline, expmethod, *args|
      logger = self.class.create_logger
      logger.set_widths(*args)
      format = logger.format

      assert_equal expfile,   format.file
      assert_equal expline,   format.line
      assert_equal expmethod, format.method
    end

    param_test [
      [ 1, 2, 3, 1, 2, 3 ],
    ].each do |expfile, expline, expmethod, file, line, method|
      logger        = self.class.create_logger
      format        = LocationFormat.new file: file, line: line, method: method
      logger.format = format
      result        = logger.format

      assert_equal expfile,   result.file
      assert_equal expline,   result.line
      assert_equal expmethod, result.method
    end

    def test_trim
      logger = self.class.create_logger
      logger.trim = false
    end

    param_test [
      [ Level::WARN,  true ],  
      [ Level::DEBUG, false ], 
    ].each do |exp, quiet|
      logger = self.class.create_logger
      logger.quiet = quiet
      assert_equal exp, logger.level
    end

    param_test [
      [ true,  Level::ERROR ], 
      [ true,  Level::WARN ],  
      [ false, Level::INFO ],  
      [ true,  Level::WARN ],  
      [ false, Level::DEBUG ], 
    ].each do |exp, level|
      logger = self.class.create_logger
      logger.level = level
      assert_equal exp, logger.quiet
    end

    param_test [
      [ Level::ERROR, Level::ERROR ], 
      [ Level::WARN,  Level::WARN ],  
      [ Level::INFO,  Level::INFO ],  
      [ Level::DEBUG, Level::DEBUG ], 
      [ Level::FATAL, false ],               
      [ Level::DEBUG, true ],                
    ].each do |exp, value|
      logger = self.class.create_logger
      logger.verbose = value
      assert_equal exp, logger.level
    end

    param_test [
      [ false,  Level::ERROR ], 
      [ false,  Level::WARN ],  
      [ false,  Level::INFO ],  
      [ true,   Level::DEBUG ], 
    ].each do |exp, value|
      logger = self.class.create_logger
      logger.level = value
      assert_equal exp, logger.verbose
    end

    param_test [
      [ Level::WARN,  true ],  
      [ Level::DEBUG, false ], 
    ].each do |exp, value|
      logger = self.class.create_logger
      logger.quiet = value
      assert_equal exp, logger.level
    end

    param_test [
      [ true,   Level::ERROR ], 
      [ true,   Level::WARN ],  
      [ false,  Level::INFO ],  
      [ false,  Level::DEBUG ], 
    ].each do |exp, value|
      logger = self.class.create_logger
      logger.level = value
      assert_equal exp, logger.quiet
    end
  end
end
