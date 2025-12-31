require 'logue/elements/element'

module Logue
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
end
