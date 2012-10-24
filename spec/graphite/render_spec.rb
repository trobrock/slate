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
    graph.url.should == "http://graphite/render?target=app.server01.load&format=png"
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
    with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => body, :headers => {})
end
