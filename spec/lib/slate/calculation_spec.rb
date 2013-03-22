require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Slate::Calculation do
  it "should list the available calculations" do
    Slate::Calculation.all.should == [Slate::Calculation::Mean, Slate::Calculation::Last]
  end
end
