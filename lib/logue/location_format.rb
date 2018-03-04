#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

module Logue
  class LocationFormat
    DEFAULT_FILENAME = -25
    DEFAULT_LINE     = 4
    DEFAULT_METHOD   = -20
    
    attr_accessor :file
    attr_accessor :line
    attr_accessor :method
    attr_accessor :trim
    
    def initialize  file: DEFAULT_FILENAME, line: DEFAULT_LINE, method: DEFAULT_METHOD, trim: true
      @file   = file
      @line   = line
      @method = method
      @trim   = trim
    end

    def copy args
      values = { file: @file, line: @line, method: @method, trim: @trim }
      self.class.new values.merge(args)
    end
    
    def format path, line, cls, func
      if cls
        func = cls.to_s + "#" + func
      end
      
      if trim
        path = PathUtil.trim_right path, @file
        func = PathUtil.trim_left  func, @method
      end
      
      sprintf format_string, path, line, func
    end

    def format_string
      "[%#{@file}s:%#{@line}d] {%#{@method}s}"
    end
  end
end
