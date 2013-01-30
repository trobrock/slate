module Slate
  module Calculation
    class Mean < Base
      protected

      def map(points)
        points.inject(0.0, :+) / points.size.to_f
      end
    end
  end
end
