module Slate
  module SlateTree
    class Target < Treetop::Runtime::SyntaxNode
      def type
        :target
      end

      def text_value
        elements.detect{ |e| e.is_a? String }.text_value
      end
    end

    class Function < Treetop::Runtime::SyntaxNode
      def type
        :function
      end

      def text_value
        elements.detect{ |e| e.is_a? Token }.text_value
      end
    end

    class Token < Treetop::Runtime::SyntaxNode
      def type
        :token
      end
    end

    class Argument < Treetop::Runtime::SyntaxNode
      def type
        :argument
      end

      def text_value
        elements.first.text_value
      end
    end

    class String < Treetop::Runtime::SyntaxNode
      def type
        :string
      end

      def text_value
        super.gsub(/"/,'')
      end
    end
  end
end
