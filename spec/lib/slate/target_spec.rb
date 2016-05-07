require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Slate::Target do
  context "build" do
    it "should return a target" do
      Slate::Target.build("some.target").should be_a Slate::Target
    end

    it "should be able to configure the target" do
      target = Slate::Target.build("some.target") do |target|
        target.add_function :sum
      end

      target.to_s.should include("sum")
    end
  end

  context "#to_s" do
    let(:target) { Slate::Target.build("some.target") }

    it "should return the target name" do
      target.to_s.should == "some.target"
    end

    it "should wrap the target with functions that have no arguments" do
      target.add_function :sum

      target.to_s.should == "sum(some.target)"
    end

    context "with a string as a function argument" do
      it "should add an argument" do
        target.add_function :summarize, "1h"

        target.to_s.should == "summarize(some.target,\"1h\")"
      end

      it "should add the arguments" do
        target.add_function :summarize, "1h", "avg"

        target.to_s.should == "summarize(some.target,\"1h\",\"avg\")"
      end
    end

    context "with a boolean as a function argument" do
      it "should add the arguments with false" do
        target.add_function :summarize, "1h", "avg", false

        target.to_s.should == "summarize(some.target,\"1h\",\"avg\",false)"
      end

      it "should add the arguments with true" do
        target.add_function :summarize, "1h", "avg", true

        target.to_s.should == "summarize(some.target,\"1h\",\"avg\",true)"
      end
    end

    context "with a number as a function argument" do
      it "should add an argument" do
        target.add_function :aliasByNode, 1

        target.to_s.should == "aliasByNode(some.target,1)"
      end

      it "should add the arguments" do
        target.add_function :aliasByNode, 1, 2

        target.to_s.should == "aliasByNode(some.target,1,2)"
      end
    end

    context "with a target as a function argument" do
      let(:other_target) { Slate::Target.build "some.new.target" }

      it "should add an argument" do
        target.add_function :asPercentOf, other_target

        target.to_s.should == "asPercentOf(some.target,some.new.target)"
      end

      it "should add the arguments" do
        target.add_function :asPercentOf, other_target, other_target

        target.to_s.should == "asPercentOf(some.target,some.new.target,some.new.target)"
      end
    end
  end
end
