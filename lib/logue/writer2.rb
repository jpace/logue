require 'logue/core/base_writer'
require 'logue/elements/element_lines'
require 'logue/elements/block_element'
require 'logue/core/object_util'

module Logue
  class Writer2 < BaseWriter
    def write_msg_obj location, msg, obj, level
      # we're not using the level, which at this point only is for colorizing output
      lines = ElementLines.new @output, location
      lines.add_msg_obj msg, obj
    end

    def write_msg_blk location, msg, level, &blk
      # we're not using the level, which at this point only is for colorizing output
      current = Array.new
      lines = ElementLines.new @output, location
      element = BlockElement.new msg, lines, &blk
      element.write_element current
    end

    def write_block location, level, &blk
      lines = ElementLines.new @output, location
      element = BlockElement.new ObjectUtil::NONE, lines, &blk
      element.write_element Array.new
    end
  end
end