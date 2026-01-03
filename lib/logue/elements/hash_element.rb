require 'logue/elements/enum_element'

module Logue
  class HashElement < EnumerableElement
    def write_element
      write_enumerator @object.each
    end
  end
end
