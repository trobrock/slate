require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Graphite::Render do
  it "should be able to get a single target" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.to_url.should == "http://graphite/render?target=app.server01.load"
  end

  it "should provide methods for retrieving formats" do
    graph = Graphite::Render.new(:target => "app.server01.load")
    graph.png_url.should  match(/format=png/)
    graph.raw_url.should  match(/format=raw/)
    graph.csv_url.should  match(/format=csv/)
    graph.json_url.should match(/format=json/)
    graph.svg_url.should  match(/format=svg/)
  end
end
