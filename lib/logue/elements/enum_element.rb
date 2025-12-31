require 'logue/elements/element'

module Logue
  class EnumerableElement < Element
    def write_enumerator msg, enum, current
      enum.each do |field, value|
        newmsg = "#{msg}[#{field}]"
        write_msg_object newmsg, value, current
      end
    end
  end
end
