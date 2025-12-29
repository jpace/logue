require 'logue/colorable'
require 'logue/loggable'
require 'logue/tc'

module Logue
  class DynamicTest < TestCase
    def self.create_logger
      Object.new.tap do |logger|
        logger.extend Logue::Loggable
        logger.extend Colorable
      end
    end

    param_test [
                 [true, :blue],
                 [true, :red],
                 [false, :no_such_color],
               ] do |exp, name|
      logger = self.class.create_logger
      assert_equal exp, logger.respond_to?(name)
    end

    def test_add_color_method
      logger = self.class.create_logger
      logger.add_class_method :foo do ||
        puts "hello, world"
      end
      assert_not_nil logger.method(:foo)
    end

    param_test [
                 [true, :blue],
                 [false, :blau],
               ] do |exp, methname|
      logger = self.class.create_logger
      assert_equal exp, logger.methods.include?(methname)
    end

    def self.colors
      [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default ]
    end

    param_test colors do |color|
      obj = self.class.create_logger
      assert_respond_to obj, color
    end

    param_test colors do |color|
      obj = self.class.create_logger
      assert obj.methods.include? color
      obj.send color
    end
  end
end
