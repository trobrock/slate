require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Slate::Parser do
  before do
    Slate.configure { |c| c.endpoint = "http://graphite" }
  end

  xit "should raise an exception if it cannot parse"

  it "should parse a basic target" do
    target = Slate::Target.build("stats.web01.response_time")

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {}
    }).to_s.should == target.to_s
  end

  it "should be able to parse a target with one function" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :sum
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" { sum }
    }).to_s.should == target.to_s
  end

  it "should be able to parse a target with one function and single arg" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :summarize, "5min"
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {
        summarize "5min"
      }
    }).to_s.should == target.to_s
  end

  it "should be able to parse a target with one function and multiple args" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :summarize, "5min", "avg"
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {
        summarize "5min", "avg"
      }
    }).to_s.should == target.to_s
  end
end
