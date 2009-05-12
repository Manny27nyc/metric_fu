require File.dirname(__FILE__) + '/../spec_helper'

describe Saikuro do
  describe "to_h method" do
    before :all do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      saikuro = MetricFu::Saikuro.new
      saikuro.stub!(:metric_directory).and_return(File.join(File.dirname(__FILE__), "..", "resources", "saikuro"))
      saikuro.analyze
      @output = saikuro.to_h
    end
  
    it "should find the filename of a file" do
      @output[:saikuro][:files].first[:filename].should == 'users_controller.rb'
    end
  
    it "should find the name of the classes" do
      @output[:saikuro][:classes].first[:name].should == "UsersController"
      @output[:saikuro][:classes][1][:name].should == "SessionsController"
    end
  
    it "should put the most complex method first" do
      @output[:saikuro][:methods].first[:name].should == "UsersController#create"
      @output[:saikuro][:methods].first[:complexity].should == 4
    end
  
    it "should find the complexity of a method" do
      @output[:saikuro][:methods].first[:complexity].should == 4
    end
  
    it "should find the lines of a method" do
      @output[:saikuro][:methods].first[:lines].should == 15
    end
  end
  
  describe "emit method" do
    it "should format the directories" do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      saikuro = MetricFu::Saikuro.new
      
      MetricFu.saikuro[:input_directory] = ["app", "lib"]
      
      File.stub!(:dirname).and_return('..')
      File.stub!(:expand_path)
      
      saikuro.should_receive(:sh).with(/"app \| lib"/)
      
      saikuro.emit
    end
  end
end
