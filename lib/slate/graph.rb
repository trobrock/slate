require 'cgi'
require 'rest_client'

module Slate
  class Graph
    def initialize(options={})
      @target = options[:target]
      @from   = options[:from]
      @until  = options[:until]
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
      options = {
        "target" => @target.to_s
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
