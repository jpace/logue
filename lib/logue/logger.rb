#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = logger.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'rainbow/x11_color_names'
require 'rainbow/color'
require 'pathname'
require 'logue/level'
require 'logue/location_format'
require 'logue/pathutil'
require 'logue/frame'
require 'logue/colorlog'
require 'logue/writer'
require 'logue/filter'
require 'logue/legacy_logger'
require 'logue/stack'

#
# == Logger
#
# This class logs messages. You probably don't want to use this directly; Log is
# the class containing the necessary class methods.
#
# == Examples
#
# See the unit tests in log_test.rb
# 

module Logue
  class Logger
    include LegacyLogger
    include ColorLog
    
    attr_accessor :output
    attr_accessor :colorize_line
    attr_accessor :level
    attr_accessor :format
    
    attr_reader :filter
    
    include Level

    def initialize
      reset
    end
    
    def verbose= v
      @level = case v
               when TrueClass 
                 DEBUG
               when FalseClass 
                 FATAL
               when Integer
                 v
               end
    end

    def verbose
      @level <= DEBUG
    end

    def reset
      @level         = FATAL
      @filter        = Filter.new
      @output        = $stdout
      @colors        = Array.new
      @colorize_line = false
      @format        = LocationFormat.new
    end
    
    def set_default_widths
      @format = LocationFormat.new
    end

    def quiet
      @level >= WARN
    end

    def quiet= b
      @level = b ? WARN : DEBUG
    end

    # Assigns output to a file with the given name. Returns the file; the client is responsible for
    # closing it.
    def outfile= f
      @output = f.kind_of?(IO) ? f : File.new(f, "w")
    end

    # Creates a printf format for the given widths, for aligning output. To lead lines with zeros
    # (e.g., "00317") the line argument must be a string, with leading zeros, not an integer.
    def set_widths file, line, method
      @format = LocationFormat.new file: file, line: line, method: method
    end

    def debug msg = "", depth = 1, cname = nil, &blk
      log msg, DEBUG, depth + 1, cname, &blk
    end

    def info msg = "", depth = 1, cname = nil, &blk
      log msg, INFO, depth + 1, cname, &blk
    end

    def warn msg = "", depth = 1, cname = nil, &blk
      log msg, WARN, depth + 1, cname, &blk
    end

    def error msg = "", depth = 1, cname = nil, &blk
      log msg, ERROR, depth + 1, cname, &blk
    end

    def fatal msg = "", depth = 1, cname = nil, &blk
      log msg, FATAL, depth + 1, cname, &blk
    end

    # Logs the given message.
    def log msg = "", lvl = DEBUG, depth = 1, cname = nil, &blk
      log_frames cname, msg, lvl, 0, &blk
    end

    # Shows the current stack.
    def stack msg = "", lvl = DEBUG, depth = 1, cname = nil, &blk
      log_frames cname, msg, lvl, -1, &blk
    end

    def log_frames cname, msg, lvl, num, &blk
      if lvl >= level
        stack = Stack.new
        stack.filtered[0 .. num].each do |frame|
          log_frame frame, cname, msg, lvl, &blk
          cname = nil
          msg   = ""
        end
      end
    end    

    def log_frame frame, cname, msg, lvl, &blk
      if @filter.log? frame.path, cname, frame.method
        print_formatted frame, cname, msg, lvl, &blk
      end
    end

    def print_formatted frame, cname, msg, lvl, &blk
      location = frame.formatted @format, cname
      writer = Writer.new output: @output, colors: @colors, colorize_line: @colorize_line
      writer.print location, msg, level, &blk
    end
    
    def set_color lvl, color
      @colors[lvl] = color
    end
  end
end
