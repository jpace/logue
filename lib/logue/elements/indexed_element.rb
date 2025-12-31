require 'logue/elements/enum_element'

module Logue
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