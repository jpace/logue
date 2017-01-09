#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

class Logue::FormatWidths
  DEFAULT_FILENAME = -25
  DEFAULT_LINENUM = 4
  DEFAULT_FUNCTION = -20
end    

class Logue::Format
  def initialize args = Hash.new
    @file_width = args.fetch :file_width, Logue::FormatWidths::DEFAULT_FILENAME
    @line_width = args.fetch :line_width, Logue::FormatWidths::DEFAULT_LINENUM
    @method_width = args.fetch :method_width, Logue::FormatWidths::DEFAULT_FUNCTION
    @trim = args.fetch :trim, true
  end
  
  def format path, lineno, cls, func
    if cls
      func = cls.to_s + "#" + func
    end
    
    if @trim
      path = Logue::PathUtil.trim_right path, @file_width
      func = Logue::PathUtil.trim_left  func, @method_width
    end
    
    format = "[%#{@file_width}s:%#{@line_width}d] {%#{@method_width}s}"
    sprintf format, path, lineno, func
  end
end
