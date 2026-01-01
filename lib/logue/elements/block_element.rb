require 'logue/elements/base_element'

module Logue
  class BlockElement < BaseElement
    def initialize msg, writer, &blk
      super writer
      @msg = msg
      @blk = blk
    end

    def write_element current
      obj = @blk.call
      write_msg_object @msg, obj, current
    end
  end
end