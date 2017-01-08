#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class FormatWidths
    DEFAULT_FILENAME = -25
    DEFAULT_LINENUM = 4
    DEFAULT_FUNCTION = -20
  end    
  
  class Format
    def initialize args = Hash.new
      @file_width = args.fetch :file_width, FormatWidths::DEFAULT_FILENAME
      @line_width = args.fetch :line_width, FormatWidths::DEFAULT_LINENUM
      @method_width = args.fetch :method_width, FormatWidths::DEFAULT_FUNCTION
      @trim = args.fetch :trim, true
    end
    
    def format frame, path, lineno, cls, func
      if cls
        func = cls.to_s + "#" + func
      end
      
      if @trim
        path = trim_right path, @file_width
        func = trim_left  func, @method_width
      end
      
      format = "[%#{@file_width}s:%#{@line_width}d] {%#{@method_width}s}"
      str = sprintf format, path, lineno, func
    end
    
    def trim_left str, maxlen
      str[0 ... maxlen.to_i.abs]
    end

    def trim_right str, maxlen
      mxln = maxlen.abs

      if str.length > mxln
        trim_path_right str, maxlen
      else
        str
      end
    end

    def trim_path_right path, maxlen
      mxln = maxlen.abs
      
      comps = path.split "/"
      str = comps.pop
      comps.reverse.each do |comp|
        newstr = comp + "/" + str
        if newstr.length + 4 <= mxln
          str = newstr
        else
          newstr = "..." + "/" + str
          if newstr.length <= mxln
            str = newstr
          end
          break
        end
      end
      str
    end    
  end
end
