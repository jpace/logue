#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class Writer
    def initialize output: $stdout, colors: Array.new, colorize_line: false
      @output = output
      @colors = colors
      @colorize_line = colorize_line
    end

    def print location, msg, lvl, &blk
      if blk
        x = blk.call
        if x.kind_of? String
          msg = x
        else
          return
        end
      end

      msg = msg.to_s.chomp
      line = line location, msg, lvl
      @output.puts line
    end

    def line location, msg, lvl
      if lvlcol = @colors[lvl]
        if @colorize_line
          line = location + " " + msg
          line.color lvlcol
        else
          location + " " + msg.color(lvlcol)
        end
      else
        location + " " + msg
      end
    end
  end
end
