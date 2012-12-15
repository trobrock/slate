module Slate
  module Calculation
    class Last < Base
      def result
        data.last
      end
    end
  end
end
