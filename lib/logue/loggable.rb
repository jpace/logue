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
    def logger
      @@logger ||= Logger.new
    end

    def logger= logger
      @@logger = logger
    end

    def respond_to_missing? *args
      true
    end

    def methods all = true
      methods_with_level + methods_without_level + super
    end

    def methods_with_level
      [ :log, :stack ]
    end

    def methods_without_level
      [ :debug, :info, :error, :fatal, :write ] + logger.valid_colors.keys
    end

    def warn msg = "", obj = nil, &blk
      logger.warn msg, obj, classname: self.class.to_s, &blk
    end
    
    def method_missing methname, *args, &blk
      # only handling foregrounds, not backgrounds
      if methods_with_level.include? methname
        add_delegator methname, true
        send methname, *args, &blk
      elsif methods_without_level.include? methname
        add_delegator methname, false
        send methname, *args, &blk
      else
        super
      end
    end

    def add_delegator methname, with_level
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
      
      instance_eval lines.join("\n")
    end
  end
end
