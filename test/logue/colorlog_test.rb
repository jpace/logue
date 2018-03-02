#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/colorlog'
require 'test/unit'
require 'paramesan'

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
      [ [ "\e[34mabc\e[0m", Level::DEBUG, 2, nil ], :blue, "abc" ],
      [ [ "\e[34mdef\e[0m", Level::DEBUG, 2, nil ], :blue, "def" ],
      [ [ "\e[34mabc\e[0m", Level::INFO,  2, nil ], :blue, "abc", Level::INFO ],
      [ [ "\e[34mabc\e[0m", Level::DEBUG, 4, nil ], :blue, "abc", Level::DEBUG, 3 ],
      [ [ "\e[34mabc\e[0m", Level::DEBUG, 2, "clsxyz" ], :blue, "abc", Level::DEBUG, 1, "clsxyz" ],
    ].each do |exp, methname, *args|
      logger = self.class.create_logger
      logger.send methname, *args
      assert_equal exp, logger.called_with
      assert_nil logger.block
    end

    param_test [
      [ [ "\e[34mabc\e[0m", Level::DEBUG, 2, nil ], :blue, Proc.new { }, "abc" ],
    ].each do |exp, methname, blk, *args|
      logger = self.class.create_logger
      logger.send methname, *args, &blk
      assert_equal exp, logger.called_with
      assert_equal blk, logger.block
    end
  end
end
