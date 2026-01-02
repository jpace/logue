module Logue
  class BaseElement
    attr_reader :writer

    def initialize writer
      @writer = writer
    end

    def write_msg_object msg, object, current
      @writer.add_msg_obj msg, object, current
    end
  end
end
