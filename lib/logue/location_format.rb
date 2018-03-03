#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

module Logue
  class LocationFormat
    DEFAULT_FILENAME = -25
    DEFAULT_LINE  = 4
    DEFAULT_FUNCTION = -20
    
    attr_accessor :file
    attr_accessor :line
    attr_accessor :function
    attr_accessor :trim
    
    def initialize  file: DEFAULT_FILENAME, line: DEFAULT_LINE, function: DEFAULT_FUNCTION, trim: true
      @file     = file
      @line     = line
      @function = function
      @trim     = trim
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
        path = PathUtil.trim_right path, @file
        func = PathUtil.trim_left  func, @function
      end
      
      sprintf format_string, path, line, func
    end

    def format_string
      "[%#{@file}s:%#{@line}d] {%#{@function}s}"
    end
  end
end
