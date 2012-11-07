#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'slate'

WINDOW = ARGV[0] || "-1w"

def log(title, value)
  format = "[%17s] %01.2f\n"
  printf format, title, value
end

Slate.configure do |c|
  c.endpoint = "http://statsd.outright.com"
end

graph = Slate::Render.new(target: "stats.timers.rack.*.response_time.upper_90", from: WINDOW)
graph.add_function :avg
graph.add_function :summarize, "1h", "avg"

app_response_time = Slate::Calculation::Mean.new(graph).result

graph = Slate::Render.new(target: "stats.rack.*.status_code.success", from: WINDOW)
graph.add_function :sum

total_graph = Slate::Render.new(target: "stats.rack.*.status_code.*", from: WINDOW)
total_graph.add_function :exclude, "missing"
total_graph.add_function :sum

graph.add_function :asPercent, total_graph

app_success_rate = Slate::Calculation::Mean.new(graph).result



graph = Slate::Render.new(target: "stats.timers.agg.thrift.*.response_time.upper_90", from: WINDOW)
graph.add_function :avg
graph.add_function :summarize, "1h", "avg"

agg_response_time = Slate::Calculation::Mean.new(graph).result


graph = Slate::Render.new(target: "stats.agg.thrift.*.status_code.success", from: WINDOW)
graph.add_function :sum

total_graph = Slate::Render.new(target: "stats.agg.thrift.*.status_code.*", from: WINDOW)
total_graph.add_function :exclude, "missing"
total_graph.add_function :sum

graph.add_function :asPercent, total_graph

agg_success_rate = Slate::Calculation::Mean.new(graph).result

log "App Response Time", app_response_time
log "App Success Rate" , app_success_rate
log "App Uptime"       , 0
print "\n"
log "Agg Response Time", agg_response_time
log "Agg Success Rate" , agg_success_rate
log "Agg Uptime"       , 0
