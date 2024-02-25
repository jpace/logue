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
require 'logue/colorable'

#
# == Loggable
#
# Including this module in a class gives access to the logger methods.
# 
# == Examples
#
# See the unit tests in loggable_test.rb
#
# == Usage
#
#  class YourClass
#    include Logue::Loggable
#
#    def some_method
#      log "my message"
# 
#  That will log from the given class and method, showing the line number from
#  which the logger was called.
#
#    def another_method
#      stack "my message"
# 
#  That will produce a stack trace from the given location.
#

module Logue
  module Loggable
    def logger
      @logger ||= Log.logger
    end

    [:stack, :log].each do |methname|
      # level as positional and named arguments, for compatibility backward and with logger
      define_method methname do |msg = '', obj = nil, lvl = nil, level: nil, &blk|
        lvalue = level || lvl || Level::DEBUG
        logger.send methname, msg, obj, level: lvalue, classname: self.class.to_s, &blk
      end
    end

    [:debug, :info, :warn, :error, :fatal, :write].each do |methname|
      define_method methname do |msg = '', obj = nil, &blk|
        logger.send methname, msg, obj, classname: self.class.to_s, &blk
      end
    end

    def logger= logger
      @logger = logger
    end
  end
end
