module Slate
  module Calculation
    class Last < Base
      name "Last Value"
      description "Returns the last point in each of the targets."

      protected

      def map(points)
        points.last
      end
    end
  end
end
