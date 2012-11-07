require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Graphite::Render do
  before(:each) do
    Graphite.configure { |c| c.endpoint = "http://graphite" }

    @png_stub  = "PNG Image Data"
    @raw_stub  = "RAW Image Data"
    @csv_stub  = "CSV,Image,Data"
    @json_stub = "{ \"JSON\": \"Image Data\" }"
    @svg_stub  = "SVG Image Data"

    stub_download :png , @png_stub
    stub_download :raw , @raw_stub
    stub_download :csv , @csv_stub
    stub_download :json, @json_stub
    stub_download :svg , @svg_stub
  end

  it "should be able to get a single target" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    query(graph.url).should include("target" => "app.server01.load", "format" => "png")
  end

  it "should be able to apply functions" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.add_function :cumulative
    graph.url.should include(CGI.escape("cumulative(app.server01.load)"))

    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.add_function :cumulative
    graph.add_function :alias, "load"
    graph.url.should include(CGI.escape("alias(cumulative(app.server01.load),\"load\""))

    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.add_function :summarize, "1s", "sum"
    graph.url.should include(CGI.escape("summarize(app.server01.load,\"1s\",\"sum\")"))

    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.add_function :movingAverage, 10
    graph.url.should include(CGI.escape("movingAverage(app.server01.load,10)"))
  end

  it "should be able to accept other graphs as options to a function" do
    graph = Graphite::Render.new(:target => "app.server01.load")

    other_graph = Graphite::Render.new(:target => "app.server*.load")
    other_graph.add_function :sum

    graph.add_function :asPercent, other_graph

    graph.url.should include(CGI.escape("asPercent(app.server01.load,sum(app.server*.load))"))
  end

  it "should be able to specify start and end times" do
    graph = Graphite::Render.new(:target => "app.server01.load", :from => "-1d")
    graph.url.should match(/from=-1d/)

    graph = Graphite::Render.new(:target => "app.server01.load", :until => "-1d")
    graph.url.should match(/until=-1d/)

    graph = Graphite::Render.new(:target => "app.server01.load", :from => "-1d", :until => "-6h")
    graph.url.should match(/from=-1d/)
    graph.url.should match(/until=-6h/)
  end

  it "should provide methods for retrieving formats" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.url(:png).should  match(/format=png/)
    graph.url(:raw).should  match(/format=raw/)
    graph.url(:csv).should  match(/format=csv/)
    graph.url(:json).should match(/format=json/)
    graph.url(:svg).should  match(/format=svg/)
  end

  it "should retrieve the graph" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.download(:png).should  eq(@png_stub)
    graph.download(:raw).should  eq(@raw_stub)
    graph.download(:csv).should  eq(@csv_stub)
    graph.download(:json).should eq(@json_stub)
    graph.download(:svg).should  eq(@svg_stub)
  end
end

def stub_download(format, body="")
  stub_request(:get, "http://graphite/render?format=#{format}&target=app.server01.load").
    to_return(:status => 200, :body => body, :headers => {})
end
