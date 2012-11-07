require 'singleton'

module Slate
  class Configuration
    include Singleton

    attr_accessor :endpoint
  end
end
