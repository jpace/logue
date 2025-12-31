require 'logue/lines/line'
require 'logue/core/base_writer'

module Logue
  class LineWriter < BaseWriter
    def write_msg_obj location, msg, obj, level, &blk
      factory = LineFactory.new
      line = factory.create msg, obj, &blk
      linestr = line.message_string
      lstr = location + " " + linestr
      print lstr, level
    end
  end
end
