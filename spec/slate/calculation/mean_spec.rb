require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

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

  it "should calculate the mean of the series" do
    calculation = Slate::Calculation::Mean.new(@graph)
    calculation.result.should == 1.5
  end
end
