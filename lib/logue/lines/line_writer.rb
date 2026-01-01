require 'logue/lines/line'
require 'logue/core/base_writer'

module Logue
  class LineWriter < BaseWriter
    def write_msg_obj location, msg, obj, level
      line = Line.new msg, obj
      write_line location, line, level
    end

    def write_msg_blk location, msg, level, &blk
      line = LineMsgBlock msg, &blk
      write_line location, line, level
    end

    def write_block location, level, &blk
      line = LineBlock.new blk
      write_line location, line, level
    end

    def write_line location, line, level
      linestr = line.message_string
      lstr = location + " " + linestr
      print lstr, level
    end
  end
end
