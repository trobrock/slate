require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Slate do
  it "should be able to configure the graphite host" do
    client = Slate.configure do |c|
      c.endpoint = "http://graphite"
    end

    client.endpoint.should == "http://graphite"
  end
end
