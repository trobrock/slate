require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Slate::Graph do
  before(:each) do
    @client = Slate.configure { |c| c.endpoint = "http://graphite" }

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

  it "should have accessors for from and until" do
    graph = Slate::Graph.new(@client, :from => "-1w")
    graph.from.should == "-1w"

    graph.from = "-1d"
    graph.from.should == "-1d"

    graph.until = "-1d"
    graph.until.should == "-1d"
  end

  it "should be able to get a single target" do
    target = Slate::Target.build("app.server01.load")
    graph = Slate::Graph.new(@client)
    graph << target
    query(graph.url).should include("target" => "app.server01.load", "format" => "png")
  end

  it "should be able to get multiple targets" do
    graph = Slate::Graph.new(@client)
    graph << Slate::Target.build("app.server01.load")
    graph << Slate::Target.build("app.server02.load")
    query(graph.url).should include("target" => ["app.server01.load", "app.server02.load"], "format" => "png")
  end

  it "should be able to apply functions" do
    target = Slate::Target.build("app.server01.load") do |t|
      t.add_function :cumulative
    end
    graph = Slate::Graph.new(@client)
    graph << target
    graph.url.should include(CGI.escape("cumulative(app.server01.load)"))

    target = Slate::Target.build("app.server01.load") do |t|
      t.add_function :cumulative
      t.add_function :alias, "load"
    end
    graph = Slate::Graph.new(@client)
    graph << target
    graph.url.should include(CGI.escape("alias(cumulative(app.server01.load),\"load\""))

    target = Slate::Target.build("app.server01.load") do |t|
      t.add_function :summarize, "1s", "sum"
    end
    graph = Slate::Graph.new(@client)
    graph << target
    graph.url.should include(CGI.escape("summarize(app.server01.load,\"1s\",\"sum\")"))

    target = Slate::Target.build("app.server01.load") do |t|
      t.add_function :movingAverage, 10
    end
    graph = Slate::Graph.new(@client)
    graph << target
    graph.url.should include(CGI.escape("movingAverage(app.server01.load,10)"))
  end

  it "should be able to accept other graphs as options to a function" do
    first_target  = Slate::Target.build("app.server*.load") do |t|
      t.add_function :sum
    end
    second_target = Slate::Target.build("app.server01.load") do |t|
      t.add_function :asPercent, first_target
    end

    graph = Slate::Graph.new(@client)
    graph << second_target

    graph.url.should include(CGI.escape("asPercent(app.server01.load,sum(app.server*.load))"))
  end

  it "should be able to specify start and end times" do
    target = Slate::Target.build("app.server01.load")
    graph = Slate::Graph.new(@client, :from => "-1d")
    graph << target
    graph.url.should match(/from=-1d/)

    graph = Slate::Graph.new(@client, :until => "-1d")
    graph << target
    graph.url.should match(/until=-1d/)

    graph = Slate::Graph.new(@client, :from => "-1d", :until => "-6h")
    graph << target
    graph.url.should match(/from=-1d/)
    graph.url.should match(/until=-6h/)
  end

  it "should provide methods for retrieving formats" do
    target = Slate::Target.build("app.server01.load")
    graph = Slate::Graph.new(@client)
    graph << target
    graph.url(:png).should  match(/format=png/)
    graph.url(:raw).should  match(/format=raw/)
    graph.url(:csv).should  match(/format=csv/)
    graph.url(:json).should match(/format=json/)
    graph.url(:svg).should  match(/format=svg/)
  end

  it "should retrieve the graph" do
    target = Slate::Target.build("app.server01.load")
    graph = Slate::Graph.new(@client)
    graph << target
    graph.download(:png).should  eq(@png_stub)
    graph.download(:raw).should  eq(@raw_stub)
    graph.download(:csv).should  eq(@csv_stub)
    graph.download(:json).should eq(@json_stub)
    graph.download(:svg).should  eq(@svg_stub)
  end

  it "should respect the configured timeout" do
    stub_request(:get, "http://graphite/render?format=png&target=app.server01.timeout").
      to_timeout

    target = Slate::Target.build("app.server01.timeout")
    graph = Slate::Graph.new(@client)
    graph << target

    expect {
      graph.download(:png).should  eq(@png_stub)
    }.to raise_error(Slate::Error::TimeoutError)
  end
end

def stub_download(format, body="")
  stub_request(:get, "http://graphite/render?format=#{format}&target=app.server01.load").
    to_return(:status => 200, :body => body, :headers => {})
end
