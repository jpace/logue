require 'logue/elements/element'
require 'logue/elements/msg_obj_element'
require 'logue/elements/block_element'
require 'logue/elements/hash_element'
require 'logue/elements/struct_element'
require 'logue/elements/indexed_element'
require 'logue/elements/msg_element'

module Logue
  class ElementFactory
    def initialize writer
      @writer = writer
    end

    def to_element msg, obj, context
      case obj
      when Element
        obj
      when Struct
        to_complex_element StructElement, msg, obj, context
      when Hash
        to_complex_element HashElement, msg, obj, context
      when Enumerable
        to_complex_element IndexedElement, msg, obj, context
      else
        to_msg_element msg, obj, context
      end
    end

    def to_complex_element cls, msg, obj, context
      if obj && context.include?(obj.object_id)
        MsgObjElement.new msg, obj.object_id.to_s + " (recursed)", context, @writer
      else
        newlist = context.dup
        newlist << obj.object_id
        cls.new msg, obj, newlist, @writer
      end
    end

    def to_msg_element msg, obj, context
      if obj == ObjectUtil::NONE || obj.nil? || obj == :none
        MsgElement.new msg, context, @writer
      else
        MsgObjElement.new msg, obj, context, @writer
      end
    end
  end
end
