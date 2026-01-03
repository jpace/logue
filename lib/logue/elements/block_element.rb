require 'logue/elements/base_element'

module Logue
  class BlockElement < BaseElement
    def initialize msg, context, writer, &blk
      super context, writer
      @msg = msg
      @blk = blk
    end

    def write_element
      obj = @blk.call
      write_msg_object @msg, obj
    end
  end
end