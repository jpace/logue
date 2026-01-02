require 'logue/core/base_writer'
require 'logue/elements/element_factory'
require 'logue/core/object_util'

module Logue
  class ElementLines
    def initialize output, location = ""
      @output = output
      @location = location
    end

    def write str
      lstr = @location + " " + str
      @output.puts lstr
    end

    def add_msg_obj msg, obj, current = Array.new
      if obj && current.include?(obj.object_id)
        add_msg_obj msg, obj.object_id.to_s + " (recursed)"
      elsif String === obj
        write_1 msg, obj
      elsif obj.nil? || obj == :none
        write msg.to_s
      else
        element = ElementFactory.to_element obj, self
        if element
          newlist = current.dup
          newlist << obj.object_id
          element.write_element msg, newlist
        else
          write_1 msg, obj
        end
      end
    end

    def write_1 msg, obj
      if msg == ObjectUtil::NONE
        write "#{obj}"
      else
        write "#{msg}: #{obj}"
      end
    end
  end
end