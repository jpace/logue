#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = loggable.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/logger'
require 'logue/log'
require 'logue/colorlog'

#
# == Loggable
#
# Including this module in a class gives access to the logger methods.
# 
# == Examples
#
# See the unit tests in log_test.rb
#
# == Usage
#
#  class YourClass
#    include Logue::Loggable
#
#    def some_method(...)
#      log "my message"
# 
#  That will log from the given class and method, showing the line number from
#  which the logger was called.
#
#    def another_method(...)
#      stack "my message"
# 
#  That will produce a stack trace from the given location.
# 

module Logue
  module Loggable
    class << self
      def add_delegator with_level, methnames
        methnames.each do |methname|
          lines = Array.new.tap do |a|
            if with_level
              a << "def #{methname} msg = '', obj = nil, level = Level::DEBUG, &blk"
              a << "  logger.send :#{methname}, msg, obj, level: level, classname: self.class.to_s, &blk"
            else
              a << "def #{methname} msg = '', obj = nil, &blk"
              a << "  logger.send :#{methname}, msg, obj, classname: self.class.to_s, &blk"
            end
            a << "end"
          end
          
          class_eval lines.join("\n")
        end
      end

      def add_color_methods colors
        colors.each do |color, code|
          class_eval ColorLog.color_method_source(color, code)
        end
      end
    end
    
    def logger
      @@logger ||= Logger.new
    end

    add_delegator true, [ :log, :stack ]
    add_delegator false, [ :debug, :info, :error, :fatal, :write ]
    add_color_methods Rainbow::Color::Named::NAMES
    
    def logger= logger
      @@logger = logger
    end

    def warn msg = "", obj = nil, &blk
      logger.warn msg, obj, classname: self.class.to_s, &blk
    end
  end
end
