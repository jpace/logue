#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = log.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/logger'
require 'logue/writer'

#
# == Log
#
# Log is the logger for anywhere within a program, writing to a single logger.
# See Loggable and Logger for more precise behavior.
# 
# Remember: all kids love log.
#
# == Examples
#
# See the unit tests in log_test.rb
#
# == Usage
#
# The most general usage is simply to call:
#
#  Logue::Log::info "some message"
#
#  That will simply log the given message.
#
#  class YourClass
#    def some_method
#      Logue::Log::debug "my message"
# 
#  That will log from the given class and method, showing the line number from
#  which the logger was called.
#
#    def another_method
#      Logue::Log::stack "my message"
# 
#  That will produce a stack trace from the given location.
# 

module Logue
  class Log
    extend Dynamic

    def self.reset
      @logger = Logger.new writer: Writer.new
    end

    reset

    # by default, class methods delegate to a single app-wide log.

    # Returns the app-wide logger of the log.
    def self.logger
      @logger
    end

    def self.logger= logger
      @logger = logger
    end

    def self.methods all = true
      super + logger.methods + colors
    end

    def self.colors
      logger.valid_colors.keys
    end

    def self.method_missing meth, *args, &blk
      if logger.respond_to? meth
        if blk
          add_class_method meth do |*args1, &blk1|
            @logger.send meth, *args1, blk1
          end
          @logger.send meth, *args, &blk
        else
          add_class_method meth do |*args1|
            @logger.send meth, *args1
          end
          @logger.send meth, *args
        end
      else
        super
      end
    end

    def self.respond_to? meth
      super || methods.include?(meth)
    end

    def self.respond_to_missing? * args
      super || methods.include?(args.first)
    end
  end
end
