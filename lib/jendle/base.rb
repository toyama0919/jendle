module Jendle
  class Base

    def initialize(core)
      @core = core
      @client = core.client
      @logger = core.logger
    end

  end
end
