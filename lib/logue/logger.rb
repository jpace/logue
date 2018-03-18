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

require 'logue/level'
require 'logue/colorlog'
require 'logue/writer'
require 'logue/filter'
require 'logue/legacy_logger'
require 'logue/location'
require 'logue/stack'
require 'logue/line'

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
    
    attr_accessor :level
    attr_accessor :format
    attr_accessor :filter
    attr_accessor :writer
    
    include Level

    def initialize format: LocationFormat.new, level: WARN, filter: Filter.new, writer: Writer.new
      reset format: format, level: level, filter: filter, writer: writer
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

    def reset format: LocationFormat.new, level: FATAL, filter: Filter.new, writer: Writer.new
      @level  = level
      @filter = filter
      @format = format
      @writer = writer
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
      io = f.kind_of?(IO) ? f : File.new(f, "w")
      @writer.output = io
    end

    # Creates a printf format for the given widths, for aligning output. To lead lines with zeros
    # (e.g., "00317") the line argument must be a string, with leading zeros, not an integer.
    def set_widths file, line, method
      @format = LocationFormat.new file: file, line: line, method: method
    end

    def debug msg = "", cname = nil, &blk
      log msg, DEBUG, cname, &blk
    end

    def info msg = "", cname = nil, &blk
      log msg, INFO, cname, &blk
    end

    def warn msg = "", cname = nil, &blk
      log msg, WARN, cname, &blk
    end

    def error msg = "", cname = nil, &blk
      log msg, ERROR, cname, &blk
    end

    def fatal msg = "", cname = nil, &blk
      log msg, FATAL, cname, &blk
    end

    # Logs the given message.
    def log msg = "", lvl = DEBUG, cname = nil, &blk
      log_frames cname, msg, lvl, 0, &blk
    end

    # Shows the current stack.
    def stack msg = "", lvl = DEBUG, cname = nil, &blk
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
        print_frame frame, cname, msg, lvl, &blk
      end
    end

    def print_frame frame, cname, msg, lvl, &blk
      loc  = Location.new frame.path, frame.line, cname, frame.method
      line = Line.new loc, msg, &blk
      lstr = line.format @format
      @writer.print lstr, level
    end
  end
end
