require 'cgi'

module Graphite
  class Render
    FORMATS = %w{ png raw csv json svg }
    FORMATS.each do |format|
      define_method "#{format}_url" do
        to_url("format" => format)
      end
    end

    def initialize(options={})
      @target = options[:target]
    end

    def to_url(options={})
      options = url_options.merge(options)
      "#{Configuration.instance.endpoint}/render?#{params(options)}"
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
