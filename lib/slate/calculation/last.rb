module Slate
  module Calculation
    class Last < Base
      protected

      def map(points)
        points.last
      end
    end
  end
end
