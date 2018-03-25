#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/logger'
require 'test_helper'

module Logue
  class LoggerTest < Test::Unit::TestCase
    include Paramesan

    def self.create_logger
      Logger.new
    end
    
    def test_init
      logger = self.class.create_logger

      assert_equal Level::WARN, logger.level
      assert_equal $stdout,     logger.output
      assert_equal false,       logger.colorize_line
      assert_equal Filter.new,  logger.filter
      assert_equal false,       logger.verbose
    end

    def test_respond_to
      logger = self.class.create_logger
      
      assert_equal true,  logger.respond_to?(:blue)
      assert_equal false, logger.respond_to?(:no_such_color)
    end

    param_test [
      [ 1, 2, 3, 1, 2, 3 ],
      [ 4, 5, 6, 4, 5, 6 ],
    ] do |expfile, expline, expmethod, *args|
      logger = self.class.create_logger
      logger.set_widths(*args)
      format = logger.format

      assert_equal expfile,   format.file
      assert_equal expline,   format.line
      assert_equal expmethod, format.method
    end

    param_test [
      [ 1, 2, 3, 1, 2, 3 ],
      [ 4, 5, 6, 4, 5, 6 ],
    ] do |expfile, expline, expmethod, file, line, method|
      logger        = self.class.create_logger
      format        = LocationFormat.new file: file, line: line, method: method
      logger.format = format
      result        = logger.format

      assert_equal expfile,   result.file
      assert_equal expline,   result.line
      assert_equal expmethod, result.method
    end
    
    param_test [
      [ Level::WARN,  true ],  
      [ Level::DEBUG, false ], 
    ] do |exp, quiet|
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
    ] do |exp, level|
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
    ] do |exp, value|
      logger = self.class.create_logger
      logger.verbose = value
      assert_equal exp, logger.level
    end

    param_test [
      [ false,  Level::ERROR ], 
      [ false,  Level::WARN ],  
      [ false,  Level::INFO ],  
      [ true,   Level::DEBUG ], 
    ] do |exp, value|
      logger = self.class.create_logger
      logger.level = value
      assert_equal exp, logger.verbose
    end

    param_test [
      [ Level::WARN,  true ],  
      [ Level::DEBUG, false ], 
    ] do |exp, value|
      logger = self.class.create_logger
      logger.quiet = value
      assert_equal exp, logger.level
    end

    param_test [
      [ true,   Level::ERROR ], 
      [ true,   Level::WARN ],  
      [ false,  Level::INFO ],  
      [ false,  Level::DEBUG ], 
    ] do |exp, value|
      logger = self.class.create_logger
      logger.level = value
      assert_equal exp, logger.quiet
    end

    def run_logging_test methname, expre, *args
      puts "expre: #{expre}"
      output = StringIO.new
      logger = Logger.new writer: Writer.new(output: output)
      logger.send methname, *args
      output.flush
      str = output.string
      puts "str: #{str}"
      assert expre.match(str)
    end

    def self.build_log_write_params
      re = Regexp.new '\[.../logue/logger_test.rb : \d+\] {cdef#.*} mabc'
      obj = "o2"
      
      params = Array.new.tap do |a|
        a << [ true,  re, :warn,  "mabc", obj, classname: "cdef" ]
        a << [ true,  re, :fatal, "mabc", obj, classname: "cdef" ]
        a << [ true,  re, :error, "mabc", obj, classname: "cdef" ]
        a << [ false, re, :debug, "mabc", obj, classname: "cdef" ]
        a << [ false, re, :info,  "mabc", obj, classname: "cdef" ]

        a << [ true,  re, :warn,  "mabc", classname: "cdef" ]
        a << [ true,  re, :fatal, "mabc", classname: "cdef" ]
        a << [ true,  re, :error, "mabc", classname: "cdef" ]
        a << [ false, re, :debug, "mabc", classname: "cdef" ]
        a << [ false, re, :info,  "mabc", classname: "cdef" ]
      end
    end

    param_test build_log_write_params do |exp, re, methname, *args|
      output = StringIO.new
      writer = Writer.new output: output
      logger = Logger.new writer: writer
      logger.send methname, *args
      output.flush
      str = output.string
      assert_equal exp, !!re.match(str)
    end
  end
end
