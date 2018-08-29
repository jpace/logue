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
    # by default, class methods delegate to a single app-wide log.

    @logger = Logger.new

    # Returns the app-wide logger of the log.
    def self.logger
      @logger
    end

    def self.accessors methname
      [ methname.to_sym, (methname.to_s + "=").to_sym ]
    end

    def self.logger_methods
      @logger_delegated ||= Array.new.tap do |ary|
        acc_methods = [
          :colorize_line,
          :format,
          :level,
          :outfile,
          :output,
          :quiet,
          :verbose,
        ]
        ary.concat acc_methods.inject(Array.new) { |a, m| a.concat accessors(m) }
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
          :error,
          :fatal,
          :info,
          :log,
          :stack,
          :warn,
          :write,
        ]
        ary.concat logging_methods
      end
    end
    
    def self.logger_delegated? meth
      self.logger_methods.include? meth
    end

    def self.methods all = true
      super + self.logger_methods + colors
    end

    def self.has_color? color
      colors.include? color
    end

    def self.colors
      logger.valid_colors.keys
    end

    def self.delegated? meth
      logger_delegated?(meth) || has_color?(meth)
    end
    
    def self.method_missing meth, *args, &blk
      if delegated? meth
        logger.send meth, *args, &blk
      else
        super
      end
    end

    def self.respond_to? meth
      methods.include? meth
    end

    def self.respond_to_missing? *args
      methods.include? args.first
    end
  end
end
