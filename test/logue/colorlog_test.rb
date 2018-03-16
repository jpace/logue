#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/colorlog'
require 'test_helper'

module Logue
  class ColorLogTest < Test::Unit::TestCase
    include Paramesan

    def self.create_logger
      Object.new.tap do |logger|
        logger.extend ColorLog
        
        class << logger
          def called_with
            @called_with
          end
          
          def block
            @block
          end
          
          def log(*args, &b)
            @called_with = args.dup
            @block = b
          end
        end
      end
    end

    param_test [
      [ true,  :blue ],
      [ true,  :red ],
      [ false, :no_such_color ], 
    ].each do |exp, name|
      logger = self.class.create_logger
      assert_equal exp, logger.respond_to?(name)
    end
    
    def test_add_color_method
      logger = self.class.create_logger
      logger.add_color_method :blue, 666
      assert_not_nil logger.method(:blue)
    end

    param_test [
      [ [ "\e[34mabc\e[0m", Level::DEBUG, nil ], :blue, "abc" ],
      [ [ "\e[34mdef\e[0m", Level::DEBUG, nil ], :blue, "def" ],
      [ [ "\e[34mabc\e[0m", Level::INFO,  nil ], :blue, "abc", Level::INFO ],
      [ [ "\e[34mabc\e[0m", Level::DEBUG, nil ], :blue, "abc", Level::DEBUG ],
      [ [ "\e[34mabc\e[0m", Level::DEBUG, "clsxyz" ], :blue, "abc", Level::DEBUG, "clsxyz" ],
    ].each do |exp, methname, *args|
      logger = self.class.create_logger
      logger.send methname, *args
      assert_equal exp, logger.called_with
      assert_nil logger.block
    end

    param_test [
      [ [ "\e[34mabc\e[0m", Level::DEBUG, nil ], :blue, Proc.new { }, "abc" ],
    ].each do |exp, methname, blk, *args|
      logger = self.class.create_logger
      logger.send methname, *args, &blk
      assert_equal exp, logger.called_with
      assert_equal blk, logger.block
    end
  end
end
