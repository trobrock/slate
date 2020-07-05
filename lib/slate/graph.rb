require 'cgi'
require 'faraday'

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
      @targets = options[:targets] || []
    end

    # Public: Adds a target to a graph.
    #
    # target - A Slate::Target instance.
    #
    # Examples
    #
    #   graph = Slate::Graph.new(client)
    #   graph << Slate::Target.build("test.metric")
    def <<(target)
      @targets << target
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
      options = url_options.merge("format" => format.to_s)
      connection.build_url(*faraday_args(format)).to_s
    end

    # Public: Retrieve the data from the graphite server in the requested format.
    #
    # format - The format of the data to return, as a Symbol (default: :png).
    #
    # Examples
    #
    #   download(:json)
    #   # => '{"targets":[]}'
    def download(format=:png)
      connection.get(*faraday_args(format)).body
    rescue Faraday::Error::TimeoutError
      raise Slate::Error::TimeoutError
    end

    private

    def faraday_args(format)
      options = url_options.merge("format" => format.to_s)
      ["#{@client.endpoint}/render", options]
    end

    def connection
      @connection ||= Faraday.new(:request => { :params_encoder => Faraday::FlatParamsEncoder }) do |faraday|
        faraday.options[:timeout] = @client.timeout || 10
        faraday.adapter Faraday.default_adapter
      end
    end

    def url_options
      options = {}
      options["target"] = @targets
      options["from"]   = @from   if @from
      options["until"]  = @until  if @until
      options
    end
  end
end
