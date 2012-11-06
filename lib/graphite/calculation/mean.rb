require "json"

module Graphite
  module Calculation
    class Mean

      def initialize(graph)
        @graph = graph
      end

      def result
        data = JSON.parse(@graph.download(:json)).first["datapoints"].map(&:first)
        sum  = data.inject(0.0, :+)

        sum / data.size.to_f
      end

    end
  end
end
