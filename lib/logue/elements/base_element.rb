module Logue
  class BaseElement
    attr_reader :writer
    attr_reader :context

    def initialize context, writer
      @context = context
      @writer = writer
    end

    def write_msg_object msg, object
      factory = ElementFactory.new @writer
      element = factory.to_element msg, object, @context
      element.write_element
    end

    def write_line str
      @writer.write_line str
    end
  end
end
