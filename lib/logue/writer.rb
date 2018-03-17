#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class Writer
    attr_accessor :output
    attr_accessor :colors
    attr_accessor :colorize_line
    
    def initialize output: $stdout, colors: Array.new, colorize_line: false
      @output        = output
      @colors        = colors
      @colorize_line = colorize_line
    end

    def print_line lstr, lvl
      str = lvlcol = @colors[lvl] ? lstr.color(lvlcol) : lstr
      @output.puts str
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
