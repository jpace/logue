#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/legacy_logger'
require 'test/unit'

module Logue
  class LegacyLoggerTest < Test::Unit::TestCase
    def self.create_logger
      Object.new.tap do |obj|
        obj.extend LegacyLogger
      end
    end
    
    def test_trim
      logger = self.class.create_logger
      logger.trim = false
    end
  end
end
