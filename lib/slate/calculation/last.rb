module Slate
  module Calculation
    class Last < Base
      name "Last Point"
      description "Returns the last point in each of the targets."

      protected

      def map(points)
        points.last
      end
    end
  end
end
