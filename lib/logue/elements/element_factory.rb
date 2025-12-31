require 'logue/elements/element'
require 'logue/elements/block_element'
require 'logue/elements/hash_element'
require 'logue/elements/struct_element'
require 'logue/elements/indexed_element'

module Logue
  module ElementFactory
    extend self

    def to_element obj, writer
      case obj
      when Element
        # in case this was created/called with a different writer, or nil
        obj.writer = writer
        obj
      when Struct
        StructElement.new obj, writer
      when Hash
        HashElement.new obj, writer
      when Enumerable
        IndexedEnumerableElement.new obj, writer
      else
        nil
      end
    end
  end
end
