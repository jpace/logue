require 'logue/core/base_writer'
require 'logue/elements/element_writer'
require 'logue/elements/block_element'
require 'logue/core/object_util'

module Logue
  class Writer2 < BaseWriter
    def write_msg_obj location, msg, obj, level
      # we're not using the level, which at this point only is for colorizing output
      writer = ElementWriter.new @output, location
      writer.write_msg_obj msg, obj
    end

    def write_msg_blk location, msg, level, &blk
      # we're not using the level, which at this point only is for colorizing output
      current = Array.new
      writer = ElementWriter.new @output, location
      element = BlockElement.new msg, writer, &blk
      element.write_element current
    end

    def write_block location, level, &blk
      writer = ElementWriter.new @output, location
      element = BlockElement.new ObjectUtil::NONE, writer, &blk
      element.write_element Array.new
    end
  end
end