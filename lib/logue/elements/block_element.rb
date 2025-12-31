require 'logue/elements/element'

module Logue
  class BlockElement < Element
    def initialize writer, &blk
      super nil, writer
      @blk = blk
    end

    def write_element msg, current
      obj = @blk.call
      write_msg_object msg, obj, current
    end
  end
end