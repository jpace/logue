require 'logue/elements/element'

module Logue
  class EnumerableElement < Element
    def write_enumerator enum
      enum.each do |field, value|
        newmsg = "#{@msg}[#{field}]"
        write_msg_object newmsg, value
      end
    end
  end
end
