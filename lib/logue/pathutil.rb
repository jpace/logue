#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class PathUtil
    class << self
      def trim_left str, maxlen
        str[0, maxlen] || ""
      end

      def trim_right str, maxlen
        if str.length > maxlen
          trim_path_right str, maxlen
        else
          str
        end
      end

      def trim_path_right path, maxlen
        return "" if maxlen < 0
        comps = path.split "/"
        str = comps.pop
        comps.reverse.each do |comp|
          newstr = comp + "/" + str
          if newstr.length + 4 <= maxlen
            str = newstr
          else
            newstr = ".../" + str
            if newstr.length <= maxlen
              str = newstr
            end
            break
          end
        end
        str
      end    
    end
  end
end
