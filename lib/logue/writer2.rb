require 'logue/writer'
require 'logue/write/element_writer'

module Logue
  class Writer2 < Writer
    def write_msg_obj location, msg, obj, level, &blk
      # we're not using the level, which at this point only is for
      # colorizing output
      writer = ElementWriter.new @output, location
      if blk
        writer.write_msg_block msg, &blk
      else
        writer.write_msg_obj msg, obj
      end
    end
  end
end