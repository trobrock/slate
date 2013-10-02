# Slate
[![Build Status](https://secure.travis-ci.org/trobrock/slate.png)](http://travis-ci.org/trobrock/slate)
[![Dependency Status](https://gemnasium.com/trobrock/slate.png)](https://gemnasium.com/trobrock/slate)
[![Coverage Status](https://coveralls.io/repos/trobrock/slate/badge.png?branch=master)](https://coveralls.io/r/trobrock/slate)
[![Code Climate](https://codeclimate.com/github/trobrock/slate.png)](https://codeclimate.com/github/trobrock/slate)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/trobrock/slate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Simple wrapper to the Graphite render api

## Installation

Add this line to your application's Gemfile:

    gem 'slate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slate

## Usage

### Configuration

Configure the Slate client

```ruby
client = Slate.configure do |config|
  config.endpoint = "http://your.graphite-server.com"
  config.timeout  = 30 # In seconds (default: 10)
end
```

### Ruby interface

To build a basic graph

```ruby
graph = Slate::Graph.new(client)
graph << Slate::Target.build("stats.web01.load")

puts graph.url
puts graph.download(:json)
```

Adjust the timeframe of the graph

```ruby
graph       = Slate::Graph.new(client)
graph.from  = "-1w"
graph.until = "-1d"
graph << Slate::Target.build("stats.web01.load")
```

Use functions

```ruby
graph = Slate::Graph.new(client)

graph << Slate::Target.build("stats.web01.load") do |target|
  target.add_function :sum
  target.add_function :alias, "load"
end
```

Or more complex targets (like passing targets to other targets): [Graph Spec](https://github.com/trobrock/slate/blob/master/spec/slate/graph_spec.rb)

### Slate text interface

Slate also provides a text interface for building targets, this can be useful if you want to enable users to create graphs.
This text interface also support being able to pass targets as arguments to functions, like you need for the `asPercentOf` function.

```ruby
graph = Slate::Graph.new(client)

target = <<-SLATE
"stats.web1.load" {
  sum
  alias "load"
}
SLATE

graph << Slate::Parser.parse(target)
```

Full test cases for different things this syntax supports are here: [Parser Spec](https://github.com/trobrock/slate/blob/master/spec/slate/parser_spec.rb)

### Calculations

Slate supports things call Calculations, which take in graphite data and boil them down to single numbers, this can be useful if you wanted to calculate the average load over the week for all your servers.

```ruby
graph = Slate::Graph.new(client)
graph << Slate::Target.build("stats.web01.load")

p Slate::Calculation::Mean.new(graph).result
# [{ "name" => "stats.web01.load", "value" => 1.5 }]
```

All the possible calculation classes are [here](https://github.com/trobrock/slate/tree/master/lib/slate/calculation).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Trae Robrock (https://github.com/trobrock)

Andrew Katz (https://github.com/andrewkatz)

David Sennerlöv (https://github.com/dsennerlov)
