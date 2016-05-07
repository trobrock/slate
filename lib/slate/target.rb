# TODO: Tests
module Slate
  class Target
    def self.build(metric, &block)
      target = new(metric)
      yield target if block_given?
      target
    end

    def initialize(metric)
      @metric    = metric
      @functions = []
    end

    def to_s
      target = @metric
      @functions.each do |function|
        if function.is_a? Symbol
          target = %Q{#{function}(#{target})}
        else
          args = arguments(function.last).join(",")
          target = %Q{#{function.first}(#{target},#{args})}
        end
      end

      target
    end

    def add_function(*function)
      if function.size > 1
        arguments = function[1..-1]
        @functions << [function.first.to_sym, arguments]
      else
        @functions << function.first.to_sym
      end

      to_s
    end

    private

    def arguments(args=[])
      args.map do |arg|
        if arg.is_a?(Numeric)
          arg.to_s
        elsif arg == true || arg == false
            arg.to_s
        elsif arg.is_a? Slate::Target
          arg.to_s
        else
          %Q{"#{arg}"}
        end
      end
    end
  end
end
