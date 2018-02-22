require 'stringio'
require 'test/unit'

class TestFrame
  attr_reader :absolute_path
  attr_reader :lineno
  attr_reader :label
  # attr_reader :base_label

  def initialize args
    @absolute_path = args[:absolute_path]
    @lineno        = args[:lineno]
    @label         = args[:label]
  end
end

module Messager
  def message(*fields)
    fields.each_slice(2).collect do |field, value|
      "#{field}: #{value}"
    end.join "; "
  end
end
