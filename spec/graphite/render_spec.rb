require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Graphite::Render do
  before(:all) do
    Graphite.configure { |c| c.endpoint = "http://graphite" }
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
  end
end
