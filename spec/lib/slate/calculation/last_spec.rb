require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

describe Slate::Calculation::Last do
  before do
    @graph = Slate::Graph.new(:target => "some.stat")
    data = [
      {
        "target" => "some.stat",
        "datapoints" => [
          [1.0, 1352143990],
          [0.0, 1352144000],
          [2.0, 1352145000],
          [3.0, 1352146000]
        ]
      }
    ]
    @graph.stubs(:download).with(:json).returns(JSON.generate(data))
  end

  it "should have a name" do
    Slate::Calculation::Last.name.should == "Last Value"
  end

  it "should have a description" do
    Slate::Calculation::Last.description.should == "Returns the last point in each of the targets."
  end

  it "should calculate the mean of the series" do
    calculation = Slate::Calculation::Last.new(@graph)
    calculation.result.should == [{ "name" => "some.stat", "value" => 3.0 }]
  end
end
