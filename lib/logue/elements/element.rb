require 'logue/elements/base_element'

module Logue
  class Element < BaseElement
    attr_reader :object

    def initialize msg, object, context, writer
      super context, writer
      @msg = msg
      @object = object
    end
  end
end
