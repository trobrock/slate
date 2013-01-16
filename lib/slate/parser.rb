require 'treetop'
require 'slate/parser/extensions'
Treetop.load File.join(File.dirname(__FILE__), 'parser', 'slate_tree')

module Slate

  class Parser
    class NotParseable < StandardError ; end

    include Singleton

    def initialize
      @parser = SlateTreeParser.new
    end

    def parse(data)
      parsed_tree = @parser.parse(data)

      raise Slate::Parser::NotParseable if parsed_tree.nil?

      parse_tree(parsed_tree)
    end

    def parse_tree(tree, target=nil)
      tree.elements.each do |element|
        next if element.terminal? && !element.respond_to?(:type)

        type = element.respond_to?(:type) ? element.type : :unknown

        case type
        when :target
          target ||= Slate::Target.build(element.elements.detect { |e| e.class == SlateTree::String }.text_value)
        when :function
          function = element.elements.detect { |e| e.class == SlateTree::Token }.text_value
          args = element.elements.last.elements.select { |e| e.class == SlateTree::Argument }.map{ |a| a.elements.first }

          target.add_function function, *args.map(&:text_value)
        end

        parse_tree(element, target) unless element.terminal?
      end

      target
    end

    def self.parse(data)
      self.instance.parse(data)
    end
  end
end
