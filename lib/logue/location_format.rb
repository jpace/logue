#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

class Logue::LocationFormatWidths
  DEFAULT_FILENAME = -25
  DEFAULT_LINE  = 4
  DEFAULT_FUNCTION = -20
end    

class Logue::LocationFormat
  attr_accessor :file
  attr_accessor :line
  attr_accessor :function
  attr_accessor :trim
  
  def initialize args = Hash.new
    @file     = args.fetch :file,     Logue::LocationFormatWidths::DEFAULT_FILENAME
    @line     = args.fetch :line,     Logue::LocationFormatWidths::DEFAULT_LINE
    @function = args.fetch :function, Logue::LocationFormatWidths::DEFAULT_FUNCTION
    @trim     = args.fetch :trim,     true
  end

  def copy args
    values = { file: @file, line: @line, function: @function, trim: @trim }
    self.class.new values.merge(args)
  end
  
  def format path, line, cls, func
    if cls
      func = cls.to_s + "#" + func
    end
    
    if trim
      path = Logue::PathUtil.trim_right path, @file
      func = Logue::PathUtil.trim_left  func, @function
    end
    
    format = "[%#{file}s:%#{@line}d] {%#{function}s}"
    sprintf format, path, line, func
  end

  def format_string
    "[%#{file}s:%#{line}d] {%#{function}s}"
  end
end
