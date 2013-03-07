# Slate
[![Build Status](https://secure.travis-ci.org/trobrock/slate.png)](http://travis-ci.org/trobrock/slate)
[![Dependency Status](https://gemnasium.com/trobrock/slate.png)](https://gemnasium.com/trobrock/slate)

Simple wrapper to the Graphite render api

## Installation

Add this line to your application's Gemfile:

    gem 'slate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slate

## Usage

### Ruby interface

To build a basic graph

```ruby
graph = Slate::Graph.new
graph << Slate::Target.build("stats.web01.load")

puts graph.url
puts graph.download(:json)
```

Adjust the timeframe of the graph

```ruby
graph       = Slate::Graph.new
graph.from  = "-1w"
graph.until = "-1d"
graph << Slate::Target.build("stats.web01.load")
```

Use functions

```ruby
graph       = Slate::Graph.new

graph << Slate::Target.build("stats.web01.load") do |target|
  target.add_function :sum
  target.add_function :alias, "load"
end
```

Or more complex targets (like passing targets to other targets): [Graph Spec](spec/slate/graph_spec.rb)


### Slate text interface

### Calculations

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Trae Robrock (https://github.com/trobrock)
Andrew Katz (https://github.com/andrewkatz)
