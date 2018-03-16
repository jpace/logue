#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/legacy_logger'
require 'logue/writer'
require 'logue/filter'
require 'test_helper'
require 'pathname'

module Logue
  class LegacyLoggerTest < Test::Unit::TestCase
    def self.create_logger
      Object.new.tap do |obj|
        obj.extend LegacyLogger

        def obj.writer
          @writer ||= Writer.new
        end

        def obj.filter
          @filter ||= Filter.new
        end

        def obj.format= fmt
          @format = fmt
        end
      end
    end
    
    def test_trim
      logger = self.class.create_logger
      $stderr.puts "expect output regarding deprecated #trim method:"
      logger.trim = false
    end
    
    def test_output
      file = File.new "/tmp/legacy_logger_test-abc", "w"
      begin
        logger = self.class.create_logger
        logger.output = file
      ensure
        Pathname.new(file).unlink
      end
    end
    
    def test_ignore_file
      logger = self.class.create_logger
      logger.ignore_file "abc"
    end
    
    def test_set_default_widths
      logger = self.class.create_logger
      logger.set_default_widths
    end
  end
end
