module Slate
  module SlateTree
    class Target < Treetop::Runtime::SyntaxNode
      def text_value
        elements.detect{ |e| e.is_a? String }.text_value
      end
    end

    class True < Treetop::Runtime::SyntaxNode
      def text_value
        true
      end
    end

    class False < Treetop::Runtime::SyntaxNode
      def text_value
        false
      end
    end

    class Function < Treetop::Runtime::SyntaxNode
      def text_value
        elements.detect{ |e| e.is_a? Token }.text_value
      end
    end

    class Token < Treetop::Runtime::SyntaxNode
    end

    class Argument < Treetop::Runtime::SyntaxNode
      def text_value
        elements.first.text_value
      end
    end

    class String < Treetop::Runtime::SyntaxNode
      def text_value
        super.gsub(/"/,'')
      end
    end

    class Integer < Treetop::Runtime::SyntaxNode
      def text_value
        super.to_i
      end
    end
  end
end
