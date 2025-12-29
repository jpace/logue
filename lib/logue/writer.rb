require 'logue/line'

module Logue
  class Writer
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

    def write_msg_obj location, msg, obj, level, &blk
      factory = LineFactory.new
      line = factory.create msg, obj, &blk
      linestr = line.message_string
      lstr = location + " " + linestr
      print lstr, level
    end

    def write_block location, level, &blk
      line = LineBlock.new blk
      linestr = line.message_string
      lstr = location + " " + linestr
      print lstr, level
    end

    def write location, str, level
      lstr = location + " " + str
      print lstr, level
    end
  end
end
