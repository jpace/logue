require 'logue/lines/line_msg_block'
require 'logue/lines/line_block'
require 'logue/lines/line_msg_obj'
require 'logue/core/base_writer'

module Logue
  class LinesWriter < BaseWriter
    def write_msg_obj location, msg, obj, level
      line = LineMsgObj.new msg, obj
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
