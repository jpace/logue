#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'logue/tc'

module Logue
  # poor man's mock
  class TestLogger
    include ColorLog
    
    attr_accessor :invoked
    
    def method_missing meth, *args, &blk
      @invoked = { name: meth, args: args }
    end

    def respond_to? meth, include_all = false
      true
    end

    # added explicitly, since :warn is a (private) method on all objects
    def warn *args
      @invoked = { name: :warn, args: args }
    end
  end

  class LoggableTest < TestCase
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
      assert obj.methods.include? color
      obj.send color
    end

    def self.build_method_delegation_params
      without_level = [
        :debug,
        :error,
        :fatal,
        :info,
        :warn,
        :write,
      ].collect do |methname|
        [ [ "m1", nil, classname: "Object" ], methname, [ "m1" ] ]
        [ [ "m1", "o1", classname: "Object" ], methname, [ "m1", "o1" ] ]
      end

      with_level = [
        :log,
        :stack,
      ].collect do |methname|
        [ [ "m1", nil, classname: "Object", level: Level::DEBUG ], methname, [ "m1" ] ]
        [ [ "m1", "o1", classname: "Object", level: Level::DEBUG ], methname, [ "m1", "o1" ] ]
      end

      without_level + with_level
    end

    param_test build_method_delegation_params do |exp, methname, args|
      obj = Object.new
      obj.extend Loggable
      lgr = obj.logger = TestLogger.new
      assert_not_same obj.logger, Logue::Log::logger
      
      lgr.invoked = nil
      obj.send methname, *args
      invoked = lgr.invoked
      assert_not_nil invoked
      assert_equal methname, invoked[:name]
      assert_equal exp, invoked[:args]
    end

    param_test [
        :debug,
        :error,
        :fatal,
        :info,
        :warn,
        :write,
        :log,
        :stack,
    ].collect do |methname|
      obj = Object.new
      obj.extend Loggable
      assert obj.methods.include?(methname)
    end    

    param_test [
        :debug,
        :error,
        :fatal,
        :info,
        :warn,
        :write,
        :log,
        :stack,
    ].collect do |methname|
      obj = Object.new
      obj.extend Loggable
      assert obj.method methname
    end

    class LG1
      include Logue::Loggable
    end

    class LG2
      include Logue::Loggable
    end

    def test_two_loggables
      x = LG1.new
      y = LG2.new
      Logue::Log::info "hello app"
      x.info "hello abc"
      y.info "greetings def"
      assert_same x.logger, y.logger
      assert_same x.logger, Logue::Log::logger
    end
  end
end
