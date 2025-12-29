require 'logue/writer'
require 'logue/elements/element'

module Logue
  class ElementWriter
    def initialize output, prefix = ""
      @output = output
      @prefix = prefix
    end

    def write str
      lstr = @prefix + " " + str
      @output.puts lstr
    end

    def write_msg_obj msg, obj, current = Array.new
      if obj && current.include?(obj.object_id)
        write_msg_obj msg, obj.object_id.to_s + " (recursed)"
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

    def write_msg_block msg, current = Array.new, &blk
      element = BlockElement.new self, &blk
      element.write_element msg, current
    end
  end
end