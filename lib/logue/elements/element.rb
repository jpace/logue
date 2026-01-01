require 'logue/elements/base_element'

module Logue
  class Element < BaseElement
    attr_reader :object

    def initialize object, writer
      super writer
      @object = object
    end
  end
end
