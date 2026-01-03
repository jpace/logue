require 'logue/elements/element'

module Logue
  class VerboseElement < Element
    def write_element
      obj = @object
      write_msg_object @msg, "verbose"
      write_msg_object @msg + ".class", obj.class
      write_msg_object @msg + ".id", obj.object_id
      write_msg_object @msg, obj
      vars = obj.instance_variables
      vars.each do |v|
        value = obj.instance_variable_get v
        write_msg_object @msg + "." + v.to_s, value
      end
    end
  end
end
