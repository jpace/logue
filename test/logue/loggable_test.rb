#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'test_helper'

module Logue
  # poor man's mock
  class TestLogger
    attr_accessor :invoked
    
    def method_missing meth, *args, &blk
      @invoked = { name: meth, args: args }
    end

    def respond_to? meth, include_all = false
      true
    end
  end
  
  class LoggableTest < Test::Unit::TestCase
    include Paramesan

    def self.colors
      [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default ]
    end

    param_test colors do |color|
      obj = Object.new
      obj.extend Loggable
      assert_respond_to obj, color
    end

    param_test colors do |color|
      obj = Object.new
      obj.extend Loggable
      obj.add_color_method color
      assert obj.methods.include? color
      obj.send color
    end

    def self.build_method_delegation_params
      without_level = [
        :debug,
        :info,
        :warn,
        :error,
        :fatal,
        :write,
      ].collect do |methname|
        [ [ "abc", classname: "Object" ], methname ]
      end

      with_level = [
        :log,
        :stack,
      ].collect do |methname|
        [ [ "abc", classname: "Object", level: Level::DEBUG ], methname ]
      end

      without_level + with_level
    end

    param_test build_method_delegation_params do |exp, methname|
      obj = Object.new
      obj.extend Loggable
      logger = obj.logger = TestLogger.new

      logger.invoked = nil
      obj.send methname, "abc"
      invoked = logger.invoked
      assert_equal methname, invoked[:name]
      assert_equal exp, invoked[:args]
    end
  end
end
