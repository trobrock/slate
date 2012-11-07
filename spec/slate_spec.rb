require File.join(File.dirname(__FILE__), 'spec_helper')

describe Slate do
  it "should be able to configure the graphite host" do
    Slate.configure do |c|
      c.endpoint = "http://graphite"
    end

    Slate.configuration.endpoint.should == "http://graphite"
  end
end
