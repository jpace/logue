#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

module Logue
  class LocationFormatWidths
    include Comparable
    
    DEFAULT_FILENAME = -25
    DEFAULT_LINE  = 4
    DEFAULT_FUNCTION = -20

    attr_reader :filename
    attr_reader :line
    attr_reader :function

    def initialize filename: DEFAULT_FILENAME, line: DEFAULT_LINE, function: DEFAULT_FUNCTION
      @filename = filename
      @line = line
      @function = function
    end

    def <=> other
      cmp = @filename <=> other.filename
      if cmp == 0
        cmp = @line <=> other.line
        if cmp == 0
          cmp = @function <=> other.function
        end
      end
      cmp
    end
  end    

  class LocationFormat
    attr_accessor :file
    attr_accessor :line
    attr_accessor :function
    attr_accessor :trim
    
    def initialize args = Hash.new
      @file     = args.fetch :file,     LocationFormatWidths::DEFAULT_FILENAME
      @line     = args.fetch :line,     LocationFormatWidths::DEFAULT_LINE
      @function = args.fetch :function, LocationFormatWidths::DEFAULT_FUNCTION
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
        path = PathUtil.trim_right path, @file
        func = PathUtil.trim_left  func, @function
      end
      
      format = "[%#{file}s:%#{@line}d] {%#{function}s}"
      sprintf format, path, line, func
    end

    def format_string
      "[%#{file}s:%#{line}d] {%#{function}s}"
    end
  end
end
