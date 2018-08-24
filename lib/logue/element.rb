#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class Element
    attr_reader :object
    
    def initialize object
      @object = object
    end

    def write output = $stdout
      output.print @object.to_s
    end
  end
end
