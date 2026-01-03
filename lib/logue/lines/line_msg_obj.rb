module Logue
  class LineMsgObj
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
end
