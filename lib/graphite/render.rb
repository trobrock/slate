require 'cgi'
require 'rest_client'

module Graphite
  class Render
    def initialize(options={})
      @target = options[:target]
    end

    def url(format=:png)
      options = url_options.merge("format" => format.to_s)
      "#{Configuration.instance.endpoint}/render?#{params(options)}"
    end

    def download(format=:png)
      RestClient.get url(format)
    end

    private

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
