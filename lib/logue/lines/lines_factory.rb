require 'logue/lines/line_msg_block'
require 'logue/lines/line_msg_obj'
require 'logue/lines/line_block'

module Logue
  class LineFactory
    def create msg, obj, &blk
      if blk
        if msg
          LineMsgBlock.new msg, blk
        else
          LineBlock.new blk
        end
      else
        LineMsgObj.new msg, obj
      end
    end
  end
end
