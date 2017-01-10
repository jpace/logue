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
require 'pathname'
require 'logue/severity'
require 'logue/format'
require 'logue/pathutil'

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
end

class Logue::Logger
  $LOGGING_LEVEL = nil

  attr_accessor :quiet
  attr_accessor :output
  attr_accessor :colorize_line
  attr_accessor :level
  attr_accessor :ignored_files
  attr_accessor :ignored_methods
  attr_accessor :ignored_classes
  
  attr_reader :output
  attr_reader :trim

  include Logue::Log::Severity

  FRAME_RE = Regexp.new('(.*):(\d+)(?::in \`(.*)\')?')

  def initialize
    set_defaults
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

  def set_defaults
    $LOGGING_LEVEL   = @level = FATAL
    @ignored_files   = Hash.new
    @ignored_methods = Hash.new
    @ignored_classes = Hash.new
    @output          = $stdout
    @colors          = Array.new
    @colorize_line   = false
    @quiet           = false
    @trim            = true

    @format = Logue::Format.new

    set_default_widths
  end

  def trim= what
  end

  def set_default_widths
    set_widths Logue::FormatWidths::DEFAULT_FILENAME, Logue::FormatWidths::DEFAULT_LINENUM, Logue::FormatWidths::DEFAULT_FUNCTION
  end

  def verbose
    level <= DEBUG
  end

  # Assigns output to a file with the given name. Returns the file; client
  # is responsible for closing it.
  def outfile= f
    @output = f.kind_of?(IO) ? f : File.new(f, "w")
  end

  # Creates a printf format for the given widths, for aligning output. To lead
  # lines with zeros (e.g., "00317") the line_width argument must be a string,
  # not an integer.
  def set_widths file_width, line_width, func_width
    @file_width = file_width
    @line_width = line_width
    @function_width = func_width
  end

  def ignore_file fname
    ignored_files[fname] = true
  end
  
  def ignore_method methname
    ignored_methods[methname] = true
  end
  
  def ignore_class classname
    ignored_classes[classname] = true
  end

  def log_file fname
    ignored_files.delete fname
  end
  
  def log_method methname
    ignored_methods.delete methname
  end
  
  def log_class classname
    ignored_classes.delete classname
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
    if lvl >= level
      frame = nil

      stk = caller 0
      stk.reverse.each_with_index do |frm, idx|
        if frm.index(%r{logue/log.*:\d+:in\b})
          break
        else
          frame = frm
        end
      end

      print_stack_frame frame, cname, msg, lvl, &blk
    end
  end

  # Shows the current stack.
  def stack msg = "", lvl = DEBUG, depth = 1, cname = nil, &blk
    if lvl >= level
      stk = caller depth
      stk.each do |frame|
        print_stack_frame frame, cname, msg, lvl, &blk
        cname = nil
        msg = ""
      end
    end
  end

  def print_stack_frame frame, cname, msg, lvl, &blk
    md = FRAME_RE.match frame
    file, line, func = md[1], md[2], (md[3] || "")
    # file.sub!(/.*\//, "")

    # Ruby 1.9 expands the file name, but 1.8 doesn't:
    pn = Pathname.new(file).expand_path
    
    file = pn.to_s

    if cname
      func = cname + "#" + func
    end
    
    if ignored_files[file] || (cname && ignored_classes[cname]) || ignored_methods[func]
    # skip this one.
    else
      print_formatted(file, line, func, msg, lvl, &blk)
    end
  end

  def print_formatted file, line, func, msg, lvl, &blk
    fmt = Logue::Format.new file_width: @file_width, line_width: @line_width, method_width: @function_width, trim: @trim
    location = fmt.format file, line, nil, func
    print location, msg, lvl, &blk
  end
  
  def print hdr, msg, lvl, &blk
    if blk
      x = blk.call
      if x.kind_of? String
        msg = x
      else
        return
      end
    end

    msg = msg.to_s.chomp

    if lvlcol = @colors[lvl]
      if colorize_line
        line = hdr + " " + msg
        @output.puts line.color(lvlcol)
      else
        @output.puts hdr + " " + msg.color(lvlcol)
      end
    else
      @output.puts hdr + " " + msg
    end      
  end

  def set_color lvl, color
    @colors[lvl] = color
  end

  def method_missing meth, *args, &blk
    # validcolors = Rainbow::X11ColorNames::NAMES
    validcolors = Rainbow::Color::Named::NAMES
    # only handling foregrounds, not backgrounds
    if code = validcolors[meth]
      add_color_method meth.to_s, code + 30
      send meth, *args, &blk
    else
      super
    end
  end

  def respond_to? meth
    validcolors = Rainbow::X11ColorNames::NAMES
    validcolors.include?(meth) || super
  end

  def add_color_method color, code
    instmeth = Array.new
    instmeth << "def #{color}(msg = \"\", lvl = DEBUG, depth = 1, cname = nil, &blk)"
    instmeth << "  log(\"\\e[#{code}m\#{msg\}\\e[0m\", lvl, depth + 1, cname, &blk)"
    instmeth << "end"
    instance_eval instmeth.join("\n")
  end
end
