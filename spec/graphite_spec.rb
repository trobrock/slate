require File.join(File.dirname(__FILE__), 'spec_helper')

describe Graphite do
  it "should be able to configure the graphite host" do
    Graphite.configure do |c|
      c.endpoint = "http://graphite"
    end

    Graphite.configuration.endpoint.should == "http://graphite"
  end
end
