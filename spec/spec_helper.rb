require "slate"
require "webmock/rspec"
require "mocha_standalone"
require "uri"
require "cgi"

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.mock_framework = :mocha
end

def query(url)
  CGI.parse(URI.parse(url).query).inject({}) do |h, x|
    key = x.first
    val = x.last
    h[key] = val.size == 1 ? val.first : val

    h
  end
end
