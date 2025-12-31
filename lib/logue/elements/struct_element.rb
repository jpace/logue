require 'logue/elements/enum_element'

module Logue
  class StructElement < EnumerableElement
    def write_element msg, current
      write_enumerator msg, @object.each_pair, current
    end
  end
end
