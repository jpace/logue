require 'logue/lines/line'

module Logue
  class BaseWriter
    attr_accessor :output
    attr_accessor :colors
    attr_accessor :colorize_line

    def initialize output: $stdout, colors: Array.new, colorize_line: false
      @output = output
      @colors = colors
      @colorize_line = colorize_line
    end

    def print lstr, lvl
      str = @colors[lvl] ? lstr.color(lvl) : lstr
      @output.puts str
    end

    def write location, str, level
      lstr = location + " " + str
      print lstr, level
    end
  end
end
