#!/usr/bin/ruby -w
# -*- ruby -*-

require 'minitest/autorun'
require 'logue/loggable'

class LoggableTest < Minitest::Test
  def test_respond_to_colors
    obj = Object.new
    obj.extend Logue::Loggable

    # from rainbow/color:
    
    colors = [
      :black,
      :red,
      :green,
      :yellow,
      :blue,
      :magenta,
      :cyan,
      :white,
      :default
    ]
    
    colors.each do |color|
      assert_respond_to obj, color, "color: #{color}"
    end
  end

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
  
  def test_delegation
    obj = Object.new
    obj.extend Logue::Loggable

    def obj.delegate_log_class
      TestLogDelegate
    end

    delegate_methods = Array.new.tap do |ary|
      ary << :log
      ary << :debug
      ary << :info
      ary << :warn
      ary << :error
      ary << :fatal
      ary << :stack
      ary << :write
    end

    delegate_methods.each do |dmeth|
      TestLogDelegate.invoked = nil
      obj.send dmeth, "abc"
      invoked = TestLogDelegate.invoked      
      assert_equal dmeth, invoked[:name], "method: #{dmeth}"
    end
  end
end
