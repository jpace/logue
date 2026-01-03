require 'logue/logger'
require 'logue/log'
require 'logue/core/base_loggable'

module Logue
  module ElementsLoggable
    include BaseLoggable

    def logger
      @logger ||= Log.logger
    end

    def logger= logger
      @logger = logger
    end
  end
end
