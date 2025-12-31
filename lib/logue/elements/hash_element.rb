require 'logue/elements/enum_element'

module Logue
  class HashElement < EnumerableElement
    def write_element msg, current
      write_enumerator msg, @object.each, current
    end
  end
end
