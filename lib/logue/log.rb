#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = log.rb
#
# Logging Module
#
# Author:: Jeff Pace
# Documentation:: Author
#

require 'logue/logger'
require 'logue/level'
require 'logue/colors'

#
# == Log
#
# Very minimal logging output. If verbose is set, this displays the method and
# line number whence called. It can be a mixin to a class, which displays the
# class and method from where it called. If not in a class, it displays only the
# method.
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
#  Log.log "some message"
#
#  That will simply log the given message.
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
  class Log
    $LOGGING_LEVEL = nil

    include Level

    # by default, class methods delegate to a single app-wide log.

    @@logger = Logger.new

    # Returns the logger of the log. A class method delegating to an instance
    # method ... not so good. But temporary.
    def self.logger
      @@logger
    end

    def self.accessors methname
      [ methname.to_sym, (methname.to_s + "=").to_sym ]
    end
    
    def self.logger_delegated? meth
      @@logger_delegated ||= Array.new.tap do |ary|
        acc_methods = [
          :colorize_line,
          :format,
          :level,
          :outfile,
          :output,
          :quiet,
          :verbose,
        ]
        ary.concat acc_methods.collect { |am| accessors(am) }.flatten!
        read_methods = [
          :ignore_class,
          :ignore_file,
          :ignore_method,
          :log_class,
          :log_file,
          :log_method,
          :set_color,
          :set_default_widths,
          :set_widths,
        ]
        ary.concat read_methods
        logging_methods = [
          :debug,
          :fatal,
          :info,
          :log,
          :stack,
        ]
        ary.concat logging_methods
      end
      @@logger_delegated.include? meth
    end
    
    def self.method_missing meth, *args, &blk
      if logger_delegated? meth
        logger.send meth, *args, &blk
      elsif Colors::valid_colors[meth]
        # only handling foregrounds, not backgrounds
        logger.send meth, *args, &blk
      else
        super
      end
    end

    def self.respond_to? meth
      logger_delegated?(meth) || Colors::valid_colors.include?(meth) || super
    end

    def self.add_color_method color, code
      meth = Array.new.tap do |a|
        a << "def #{color} msg = '', lvl = Log::DEBUG, cname = nil, &blk"
        a << "  logger.#{color} (\"\\e[#{code}m\#{msg\}\\e[0m\", lvl, classname: cname, &blk)"
        a << "end"
      end
      
      # an instance, but on the class object, not the log instance:
      self.instance_eval meth.join("\n")
    end

    def self.warn msg = "", classname: nil, &blk
      if verbose
        logger.log msg, WARN, classname: classname, &blk
      else
        $stderr.puts "WARNING: " + msg
      end
    end

    def self.error msg = "", classname: nil, &blk
      if verbose
        logger.log msg, ERROR, classname: classname, &blk
      else
        $stderr.puts "ERROR: " + msg
      end
    end

    def self.write msg, classname: nil, &blk
      if verbose
        stack msg, Log::WARN, classname: classname, &blk
      elsif quiet
        # nothing
      else
        $stderr.puts msg
      end
    end
  end
end
