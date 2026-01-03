require 'logue/elements/element'

module Logue
  class MsgElement < Element
    def initialize msg, context, writer
      super msg, ObjectUtil::NONE, context, writer
    end

    def write_element
      write_line @msg
    end
  end
end
