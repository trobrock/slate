require 'cgi'
require 'rest-client'

module Slate
  class Graph
    attr_accessor :from, :until

    # Public: Creates a new graph instance.
    #
    # client  - A configured Slate::Client instance.
    # options - Options for creating the graph (default: {}):
    #           :from  - The String to start the data in the graph (optional).
    #           :until - The String to end the data in the graph (optional).
    #
    # Examples
    #
    #   Slate::Graph.new(client)
    #
    #   Slate::Graph.new(client, { from: "-1d" })
    #
    #   Slate::Graph.new(client, { until: "-1h" })
    def initialize(client, options={})
      @client  = client
      @from    = options[:from]
      @until   = options[:until]
    end

    def <<(target)
      @target = target
    end

    # Public: Generate a URL to the image of the graph.
    #
    # format - The format of the graph to return, as a Symbol (default: :png).
    #
    # Examples
    #
    #   url
    #   # => "http://example.com/render?format=png"
    #
    #   url(:svg)
    #   # => "http://example.com/render?format=svg"
    #
    # Returns the URL String.
    def url(format=:png)
      options = url_options.push(["format", format.to_s])
      "#{@client.endpoint}/render?#{params(options)}"
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
