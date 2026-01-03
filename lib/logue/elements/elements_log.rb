require 'logue/log'
require 'logue/elements/elements_writer'

#
# == ElementsLog
#
# ElementsLog uses the extended format for formatting complex elements instead
# of using only their to-string methods.
# 
# See Log.
#
module Logue
  class ElementsLog < Log
    def self.reset
      logger = Logger.new writer: ElementsWriter.new
      Log.logger = logger
    end

    reset
  end
end
