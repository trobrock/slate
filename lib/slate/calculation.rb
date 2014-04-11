require 'json'

module Slate
  module Calculation
    def self.all
      [Mean, Last]
    end

    class Base
      def self.name(name=nil)
        return @name if name.nil?
        @name = name
      end

      def self.description(description=nil)
        return @description if description.nil?
        @description = description
      end

      def initialize(graph)
        @graph = graph
      end

      def result
        targets.map do |target|
          name = target.first
          points = target.last
          target name, map(points)
        end
      end

      protected

      # This is the method to do calculations in children classes
      def map(points)
        points
      end

      def targets
        data.map { |t| [t["target"], t["datapoints"].map(&:first).compact] }
      end

      def target(name, value)
        {
          "name"  => name,
          "value" => value
        }
      end

      def data
        @data ||= begin
                    JSON.parse(@graph.download(:json))
                  rescue JSON::ParserError
                    []
                  end
      end
    end
  end
end
