require "graphite/version"
require "graphite/configuration"
require "graphite/render"

module Graphite
  def self.configure
    yield Configuration.instance
  end

  def self.configuration
    Configuration.instance
  end
end
