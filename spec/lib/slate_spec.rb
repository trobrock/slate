require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Slate do
  it "should be able to configure the graphite host" do
    client = Slate.configure do |c|
      c.endpoint = "http://graphite"
    end

    client.endpoint.should == "http://graphite"
  end

  it "should be able to configure the request timeout" do
    client = Slate.configure do |c|
      c.timeout = 30
    end

    client.timeout.should == 30
  end
end
