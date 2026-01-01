require 'logue/elements/element'

module Logue
  class BlockElement < Element
    def initialize msg, writer, &blk
      super nil, writer
      @msg = msg
      @blk = blk
    end

    def write_element current
      obj = @blk.call
      write_msg_object @msg, obj, current
    end
  end
end