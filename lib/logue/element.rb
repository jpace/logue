#!/usr/bin/ruby -w
# -*- ruby -*-

module Logue
  class Element
    attr_reader :object
    
    def initialize object
      @object = object
    end

    def write output = $stdout
      strs = lines
      output.print strs
    end

    def lines
      if Enumerable === @object
        @object.to_s + " (#:#{@object.size})"
      else
        @object.to_s
      end
    end
  end
end
