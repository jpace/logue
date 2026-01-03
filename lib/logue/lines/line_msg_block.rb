module Logue
  class LineMsgBlock
    def initialize msg, blk
      @msg = msg
      @blk = blk
    end

    def message_string
      @msg.to_s + ": " + @blk.call.to_s
    end
  end
end
