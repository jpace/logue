require 'logue/elements/element'

module Logue
  class LineFactory
    def create msg, obj, &blk
      if blk
        LineBlock.new blk
      else
        Line.new msg, obj
      end
    end
  end

  class Line
    attr_reader :msg
    attr_reader :obj

    def initialize msg, obj = nil
      @msg = msg
      @obj = obj
    end

    def message_string
      if @obj
        @msg.to_s + ": " + @obj.to_s
      else
        @msg.to_s
      end
    end
  end

  class LineBlock
    def initialize blk
      @blk = blk
    end

    def message_string
      @blk.call.to_s
    end
  end
end
