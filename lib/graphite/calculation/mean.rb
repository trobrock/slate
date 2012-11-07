module Graphite
  module Calculation
    class Mean < Base
      def result
        data.inject(0.0, :+) / data.size.to_f
      end
    end
  end
end
