require 'json'

module Graphite
  module Calculation
    class Base
      def initialize(graph)
        @graph = graph
      end

      def result
        nil # Override this
      end

      protected

      def data
        @data ||= JSON.parse(@graph.download(:json)).first["datapoints"].map(&:first).compact
      end
    end
  end
end
