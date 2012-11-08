require 'cgi'
require 'rest_client'

module Slate
  class Graph
    def initialize(options={})
      @from    = options[:from]
      @until   = options[:until]
    end

    def <<(target)
      @target = target
    end

    def url(format=:png)
      options = url_options.push(["format", format.to_s])
      "#{Configuration.instance.endpoint}/render?#{params(options)}"
    end

    def download(format=:png)
      RestClient.get url(format)
    end

    private

    def url_options
      options = []
      options << ["target", @target.to_s]
      options << ["from", @from]   if @from
      options << ["until", @until] if @until

      options
    end

    def params(options={})
      options.map do |param|
        key   = param.first
        value = param.last
        "#{CGI.escape(key)}=#{CGI.escape(value)}"
      end.join("&")
    end
  end
end
