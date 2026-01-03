module Logue
  class LineBlock
    def initialize blk
      @blk = blk
    end

    def message_string
      @blk.call.to_s
    end
  end
end
