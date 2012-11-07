require 'cgi'
require 'rest_client'

module Graphite
  class Render
    def initialize(options={})
      @target = options[:target]
      @from   = options[:from]
      @until  = options[:until]
      @functions = []
    end

    def url(format=:png)
      options = url_options.merge("format" => format.to_s)
      "#{Configuration.instance.endpoint}/render?#{params(options)}"
    end

    def download(format=:png)
      RestClient.get url(format)
    end

    def add_function(*function)
      if function.size > 1
        arguments = function[1..-1]
        @functions << [function.first.to_sym, arguments]
      else
        @functions << function.first.to_sym
      end

      target
    end

    def target
      target = @target
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

    private

    def arguments(args=[])
      args.map do |arg|
        if arg.is_a?(Numeric)
          arg.to_s
        elsif arg.is_a?(Graphite::Render)
          arg.send(:target)
        else
          %Q{"#{arg}"}
        end
      end
    end

    def url_options
      options = {
        "target" => target
      }
      options["from"]  = @from if @from
      options["until"] = @until if @until

      options
    end

    def params(options={})
      options.map do |key,value|
        "#{CGI.escape(key)}=#{CGI.escape(value)}"
      end.join("&")
    end
  end
end
