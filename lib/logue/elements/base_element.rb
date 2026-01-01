module Logue
  class BaseElement
    attr_reader :writer

    def initialize writer
      @writer = writer
    end

    def write_msg_object msg, object, current
      @writer.write_msg_obj msg, object, current
    end
  end
end
