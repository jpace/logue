#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/pathutil'

module Logue
  class LocationFormat
    module Defaults
      FILENAME = -25
      LINE     =   4
      METHOD   = -20
    end
    
    attr_accessor :file
    attr_accessor :line
    attr_accessor :method
    attr_accessor :trim
    
    def initialize  file: Defaults::FILENAME, line: Defaults::LINE, method: Defaults::METHOD, trim: true
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
        path = PathUtil.trim_right path.to_s, @file
        func = PathUtil.trim_left  func,      @method
      end
      
      sprintf format_string, path, line, func
    end

    def format_string
      "[%#{@file}s:%#{@line}d] {%#{@method}s}"
    end
  end
end
