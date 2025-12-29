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

require 'logue/colorable'
require 'logue/writer'
require 'logue/filter'
require 'logue/legacy_logger'
require 'logue/locations/stack'
require 'logue/line'
require 'logue/locations/location'
require 'logue/core/object_util'

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
    include Colorable

    attr_accessor :level
    attr_accessor :format
    attr_accessor :filter
    attr_accessor :writer

    def initialize format: LocationFormat.new, level: Level::WARN, filter: Filter.new, writer: Writer.new
      reset format: format, level: level, filter: filter, writer: writer
    end

    def verbose= v
      @level = case v
               when TrueClass
                 Level::DEBUG
               when FalseClass
                 Level::FATAL
               else
                 v
               end
    end

    def verbose
      @level <= Level::DEBUG
    end

    def reset format: LocationFormat.new, level: FATAL, filter: Filter.new, writer: Writer.new
      @level = level
      @filter = filter
      @format = format
      @writer = writer
    end

    def quiet?
      @level >= Level::WARN
    end

    def quiet= b
      @level = b ? Level::WARN : Level::DEBUG
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

    { :debug => Level::DEBUG, :info => Level::INFO, :warn => Level::WARN, :error => Level::ERROR, :fatal => Level::FATAL, :write => Level::WARN }.each do |methname, level|
      define_method methname do |msg = ObjectUtil::NONE, obj = nil, classname: nil, &blk|
        log msg, obj, level: level, classname: classname, &blk
      end
    end

    # Logs the given message.
    def log msg = ObjectUtil::NONE, obj = ObjectUtil::NONE, level: Level::DEBUG, classname: nil, &blk
      log_frames msg, obj, classname: classname, level: level, nframes: 0, &blk
    end

    # Writes the current stack, from where this method was invoked.
    def stack msg = ObjectUtil::NONE, obj = ObjectUtil::NONE, level: Level::DEBUG, classname: nil, &blk
      log_frames msg, obj, classname: classname, level: level, nframes: -1, &blk
    end

    def log_frames msg, obj = ObjectUtil::NONE, classname: nil, level: nil, nframes: -1, &blk
      if level >= @level
        stack = Stack.new
        stack.filtered[0..nframes].each do |frame|
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
      location = Location.new frame.path, frame.line, classname, frame.method
      locstr = @format.format_location location
      if msg == ObjectUtil::NONE
        @writer.write_block locstr, level, &blk
      elsif blk
        @writer.write_msg_obj locstr, msg, obj, level, &blk
      else
        @writer.write_msg_obj locstr, msg, obj, level
      end
    end
  end
end
