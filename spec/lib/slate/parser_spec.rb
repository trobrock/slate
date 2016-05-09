require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Slate::Parser do
  before do
    Slate.configure { |c| c.endpoint = "http://graphite" }
  end

  it "should raise an exception if it cannot parse" do
    expect {
      Slate::Parser.parse(nil)
    }.to raise_error(Slate::NotParseable)

    expect {
      Slate::Parser.parse("bob")
    }.to raise_error(Slate::NotParseable)
  end

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

  it "should be able to parse a target with one function and single integer arg" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :aliasByNode, 3
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {
        aliasByNode 3
      }
    }).to_s.should == target.to_s
  end

  it "should be able to parse a target with one function and multiple args" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :summarize, "5min", "avg", true
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {
        summarize "5min", "avg", true
      }
    }).to_s.should == target.to_s
  end

  it "should be able to parse a target with multiple functions" do
    target = Slate::Target.build("stats.web01.response_time") do |t|
      t.add_function :sum
      t.add_function :summarize, "5min", "avg", false
    end

    Slate::Parser.parse(%q{
      "stats.web01.response_time" {
        sum
        summarize "5min", "avg", false
      }
    }).to_s.should == target.to_s
  end

  it "should be able to parse a really complex target" do
    nested_target = Slate::Target.build("stats_counts.rack.*.status_code.*") do |t|
      t.add_function :exclude, "missing"
      t.add_function :sum
    end

    target = Slate::Target.build("stats_counts.rack.*.status_code.success") do |t|
      t.add_function :sum
      t.add_function :asPercent, nested_target
    end

    Slate::Parser.parse(%q{
      "stats_counts.rack.*.status_code.success" {
        sum
        asPercent "stats_counts.rack.*.status_code.*" {
          exclude "missing"
          sum
        }
      }
    }).to_s.should == target.to_s
  end
end
