#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/colorlog'
require 'logue/tc'

module Logue
  class ColorLogTest < TestCase
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
      # [ true,  :blue ],
      # [ true,  :red ],
      [ false, :no_such_color ], 
    ] do |exp, name|
      logger = self.class.create_logger
      assert_equal exp, logger.respond_to?(name)
    end
    
    def test_add_color_method
      logger = self.class.create_logger
      logger.add_color_method :blue, 666
      assert_not_nil logger.method(:blue)
    end

    def self.build_call_color_method_params
      sabc = "\e[34mabc\e[0m"
      sdef = "\e[34mdef\e[0m"
      
      Array.new.tap do |a|
        # a << [ [ sabc, level: Level::DEBUG, classname: nil ], :blue, "abc" ]
        # a << [ [ sdef, level: Level::DEBUG, classname: nil ], :blue, "def" ]
        # a << [ [ sabc, level: Level::INFO,  classname: nil ], :blue, "abc", Level::INFO ]
        # a << [ [ sabc, level: Level::DEBUG, classname: nil ], :blue, "abc", Level::DEBUG ]
        # a << [ [ sabc, level: Level::DEBUG, classname: "clsxyz" ], :blue, "abc", Level::DEBUG, classname: "clsxyz" ]
      end
    end

    param_test build_call_color_method_params do |exp, methname, *args|
      logger = self.class.create_logger
      logger.send methname, *args
      assert_equal exp, logger.called_with
      assert_nil logger.block
    end

    param_test [
      # [ [ "\e[34mabc\e[0m", level: Level::DEBUG, classname: nil ], :blue, Proc.new { }, "abc" ],
    ] do |exp, methname, blk, *args|
      logger = self.class.create_logger
      logger.send methname, *args, &blk
      assert_equal exp, logger.called_with
      assert_equal blk, logger.block
    end

    param_test [
      # [ true, :blue ],
      [ false, :blau ],
    ] do |exp, methname|
      logger = self.class.create_logger
      assert_equal exp, logger.methods.include?(methname)
    end
  end
end
