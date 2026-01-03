require 'logue/core/base_writer'
require 'logue/elements/element_factory'
require 'logue/core/object_util'

module Logue
  class ElementLines
    def initialize io, location = ""
      @io = io
      @factory = ElementFactory.new self
      @location = location
    end

    def write_line str
      lstr = @location + " " + str
      @io.puts lstr
    end

    def add_msg_obj msg, obj, context = Array.new
      element = @factory.to_element msg, obj, context
      element.write_element
    end
  end
end