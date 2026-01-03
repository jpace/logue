require 'logue/locations/location'

module Logue
  class LocationWriter
    def initialize format
      @format = format
    end

    def to_string location
      @format.format_location location
    end
  end
end
