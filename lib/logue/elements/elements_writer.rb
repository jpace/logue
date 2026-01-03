require 'logue/core/base_writer'
require 'logue/elements/element_lines'
require 'logue/elements/block_element'
require 'logue/core/object_util'

module Logue
  class ElementsWriter < BaseWriter
    def write_msg_obj location, msg, obj, level
      # we're not using the level, which at this point only is for colorizing output
      lines = ElementLines.new @output, location
      factory = ElementFactory.new lines
      element = factory.to_element msg, obj, Array.new
      write_element element
    end

    def write_msg_blk location, msg, level, &blk
      # we're not using the level, which at this point only is for colorizing output
      lines = ElementLines.new @output, location
      element = BlockElement.new msg, Array.new, lines, &blk
      write_element element
    end

    def write_block location, level, &blk
      lines = ElementLines.new @output, location
      element = BlockElement.new ObjectUtil::NONE, Array.new, lines, &blk
      write_element element
    end

    def write_element element
      element.write_element
    end
  end
end