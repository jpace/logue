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

    def debug msg = "", obj = nil, classname: nil, &blk
      log msg, level: DEBUG, classname: classname, &blk
    end

    def info msg = "", obj = nil, classname: nil, &blk
      log msg, level: INFO, classname: classname, &blk
    end

    def warn msg = "", obj = nil, classname: nil, &blk
      log msg, level: WARN, classname: classname, &blk
    end

    def error msg = "", obj = nil, classname: nil, &blk
      log msg, level: ERROR, classname: classname, &blk
    end

    def fatal msg = "", obj = nil, classname: nil, &blk
      log msg, level: FATAL, classname: classname, &blk
    end

    # Logs the given message.
    def log msg = "", obj = nil, level: DEBUG, classname: nil, &blk
      log_frames msg, classname: classname, level: level, nframes: 0, &blk
    end

    # Shows the current stack.
    def stack msg = "", obj = nil, level: DEBUG, classname: nil, &blk
      log_frames msg, classname: classname, level: level, nframes: -1, &blk
    end

    def log_frames msg, obj = nil, classname: nil, level: nil, nframes: -1, &blk
      if level >= @level
        stack = Stack.new
        stack.filtered[0 .. nframes].each do |frame|
          log_frame frame, msg, obj, classname: classname, level: level, &blk
          classname = nil
          msg = ""
          obj = nil
        end
      end
    end    

    def log_frame frame, msg, obj, classname: nil, level: nil, &blk
      if @filter.log? frame.path, classname, frame.method
        print_frame frame, msg, obj, classname: classname, level: level, &blk
      end
    end

    def print_frame frame, msg, obj, classname: nil, level: nil, &blk
      loc  = Location.new frame.path, frame.line, classname, frame.method
      line = Line.new loc, msg, &blk
      lstr = line.format @format
      @writer.print lstr, level
    end
  end
end
