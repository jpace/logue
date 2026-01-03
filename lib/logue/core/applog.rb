require 'singleton'

module Logue
  class AppLog
    include Singleton

    def use_legacy

    end

    def use_new
    end

    def loggable
      ElementsLoggable
    end
  end
end
