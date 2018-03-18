#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'test_helper'

module Logue
  # poor man's mock
  class TestLogDelegate
    class << self
      attr_accessor :invoked
      
      def method_missing meth, *args, &blk
        @invoked = { name: meth, args: args }
      end

      def respond_to? meth, include_all = false
        true
      end
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
      assert_respond_to obj, color, "color: #{color}"
    end

    param_test colors do |color|
      obj = Object.new
      obj.extend Loggable
      obj.add_color_method color
      assert obj.methods.include? color
      obj.send color
    end

    param_test [
      :log,
      :debug,
      :info,
      :warn,
      :error,
      :fatal,
      :stack,
      :write,
    ] do |methname|
      obj = Object.new
      obj.extend Loggable

      def obj.delegate_log_class
        TestLogDelegate
      end

      TestLogDelegate.invoked = nil
      obj.send methname, "abc"
      invoked = TestLogDelegate.invoked      
      assert_equal methname, invoked[:name]
    end
  end
end
