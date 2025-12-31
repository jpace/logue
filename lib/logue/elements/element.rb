module Logue
  class Element
    attr_reader :object
    attr_accessor :writer

    def initialize object, writer
      @object = object
      @writer = writer
    end

    def lines
      @object.to_s
    end

    def write_msg_object msg, object, current
      @writer.write_msg_obj msg, object, current
    end
  end
end
