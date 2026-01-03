require 'logue/elements/enum_element'

module Logue
  class StructElement < EnumerableElement
    def write_element
      write_enumerator @object.each_pair
    end
  end
end
