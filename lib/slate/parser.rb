require 'treetop'
require 'singleton'
require 'slate/parser/extensions'
Treetop.load File.join(File.dirname(__FILE__), 'parser', 'slate_tree')

module Slate
  class NotParseable < StandardError ; end

  class Parser
    include Singleton

    def self.parse(data)
      self.instance.parse(data)
    end

    def initialize
      @parser = SlateTreeParser.new
    end

    def parse(data)
      raise Slate::NotParseable if data.nil?

      parsed_tree = @parser.parse(data)

      raise Slate::NotParseable if parsed_tree.nil?

      parse_tree(parsed_tree)
    end

    private

    def parse_tree(element, target=nil)
      case element
      when SlateTree::Target
        target ||= Slate::Target.build(element.text_value)
      when SlateTree::Function
        args = arguments(element).map do |arg|
          if is_target? arg
            parse_tree arg
          else
            arg.text_value
          end
        end

        target.add_function element.text_value, *args
      end
      element.elements.each { |e| target = parse_tree(e, target) } if should_recurse?(element)

      target
    end

    def arguments(element)
      element.elements.last.elements.select do |e|
        is_argument?(e) || is_target?(e)
      end
    end

    def should_recurse?(element)
      !element.terminal? && !is_function?(element)
    end

    def is_function?(element)
      element.is_a? SlateTree::Function
    end

    def is_argument?(element)
      element.is_a? SlateTree::Argument
    end

    def is_target?(element)
      element.is_a? SlateTree::Target
    end
  end
end
