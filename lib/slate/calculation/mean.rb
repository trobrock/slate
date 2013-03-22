module Slate
  module Calculation
    class Mean < Base
      name "Average"
      description "Calculates the average of all points in each of the targets."

      protected

      def map(points)
        points.inject(0.0, :+) / points.size.to_f
      end
    end
  end
end
