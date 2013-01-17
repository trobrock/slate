require "slate/version"
require "slate/configuration"
require "slate/target"
require "slate/graph"
require "slate/calculation"
require "slate/parser"

require "slate/calculation/mean"
require "slate/calculation/last"

module Slate
  def self.configure
    yield Configuration.instance
  end

  def self.configuration
    Configuration.instance
  end
end
