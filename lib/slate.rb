require "slate/version"
require "slate/error"
require "slate/client"
require "slate/target"
require "slate/graph"
require "slate/calculation"
require "slate/parser"

require "slate/calculation/mean"
require "slate/calculation/last"

module Slate
  # Public: Configures a new Client instance.
  #
  # Yields the Client instance to configure.
  #
  # Examples
  #
  #   Slate.configure do |config|
  #     config.endpoint = "http://example.com"
  #   end
  #   # => Slate::Client
  #
  # Returns a configured Client instance.
  def self.configure
    client = Client.new
    yield client
    client
  end
end
