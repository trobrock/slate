require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

describe Slate::Calculation::Mean do
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
    Slate::Calculation::Mean.name.should == "Average"
  end

  it "should have a description" do
    Slate::Calculation::Mean.description.should == "Calculates the average of all points in each of the targets."
  end

  it "should calculate the mean of the series" do
    calculation = Slate::Calculation::Mean.new(@graph)
    calculation.result.should == [{ "name" => "some.stat", "value" => 1.5 }]
  end
end
