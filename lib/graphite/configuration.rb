require 'singleton'

module Graphite
  class Configuration
    include Singleton

    attr_accessor :endpoint
  end
end
