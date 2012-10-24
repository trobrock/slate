require 'cgi'
require 'rest_client'

module Graphite
  class Render
    def initialize(options={})
      @target = parse_target(options[:target])
    end

    def url(format=:png)
      options = url_options.merge("format" => format.to_s)
      "#{Configuration.instance.endpoint}/render?#{params(options)}"
    end

    def download(format=:png)
      RestClient.get url(format)
    end

    private

    def parse_target(target)
      return target if target.is_a? String

      functions = target.last
      target    = target.first

      functions.each do |function, args|
        if args == true
          target = %Q{#{function}(#{target})}
        else
          args = [args].flatten.map{ |arg| %Q{"#{arg}"} }.join(",")
          target = %Q{#{function}(#{target},#{args})}
        end
      end

      target
    end

    def url_options
      {
        "target" => @target
      }
    end

    def params(options={})
      options.map do |key,value|
        "#{CGI.escape(key)}=#{CGI.escape(value)}"
      end.join("&")
    end
  end
end
