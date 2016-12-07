#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class Format
    
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

    def print_formatted file, line, func, msg, lvl, &blk
      if trim
        file = trim_right file, @file_width
        line = trim_left  line, @line_width
        func = trim_left  func, @function_width
      end

      hdr = sprintf @format, file, line, func
      print hdr, msg, lvl, &blk
    end
  end
end
