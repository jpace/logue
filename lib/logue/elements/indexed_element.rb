require 'logue/elements/enum_element'

module Logue
  class IndexedElement < EnumerableElement
    def write_element msg, current
      if @object.respond_to? :size
        write_msg_object "#{msg}.#", @object.size, current
      end
      @object.each_with_index do |value, index|
        newmsg = "#{msg}[#{index}]"
        write_msg_object newmsg, value, current
      end
    end
  end
end