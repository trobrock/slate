require "graphite/version"
require "graphite/configuration"
require "graphite/render"
require "graphite/calculation"

require "graphite/calculation/mean"

module Graphite
  def self.configure
    yield Configuration.instance
  end

  def self.configuration
    Configuration.instance
  end
end
