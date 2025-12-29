module Logue
  class Element
    attr_reader :object
    attr_accessor :writer

    def initialize object, writer
      @object = object
      @writer = writer
    end

    def lines
      @object.to_s
    end

    def write_msg_object msg, object, current
      @writer.write_msg_obj msg, object, current
    end
  end

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

  class VerboseElement < Element
    def write_element msg, current
      obj = @object
      write_msg_object msg, "verbose", current
      write_msg_object msg + ".class", obj.class, current
      write_msg_object msg + ".id", obj.object_id, current
      write_msg_object msg, obj, current
      vars = obj.instance_variables
      vars.each do |v|
        value = obj.instance_variable_get v
        write_msg_object msg + "." + v.to_s, value, current
      end
    end
  end

  class BlockElement < Element
    def initialize writer, &blk
      super nil, writer
      @blk = blk
    end

    def write_element msg, current
      obj = @blk.call
      write_msg_object msg, obj, current
    end
  end

  class EnumerableElement < Element
    def write_enumerator msg, enum, current
      enum.each do |field, value|
        newmsg = "#{msg}[#{field}]"
        write_msg_object newmsg, value, current
      end
    end
  end

  class StructElement < EnumerableElement
    def write_element msg, current
      write_enumerator msg, @object.each_pair, current
    end
  end

  class HashElement < EnumerableElement
    def write_element msg, current
      write_enumerator msg, @object.each, current
    end
  end

  class IndexedEnumerableElement < EnumerableElement
    def write_element msg, current
      if @object.respond_to? :size
        write_msg_object "#{msg}.#", @object.size, current
      end
      # need the indices first (each_with_index is <value, index>)
      ary = (0...@object.size).to_a.zip @object.to_a
      write_enumerator msg, ary, current
    end
  end
end
