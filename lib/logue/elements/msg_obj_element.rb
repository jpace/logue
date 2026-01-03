require 'logue/elements/element'

module Logue
  class MsgObjElement < Element
    def write_element
      if @msg == ObjectUtil::NONE
        write_line @object.to_s
      else
        write_line "#{@msg}: #{@object}"
      end
    end
  end
end
