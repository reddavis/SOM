require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Som" do
  describe "Initialization" do
    before do
      @a = SOM.new(:nodes => 10, :dimensions => 5)
    end
    
    it "should have 10 nodes" do
      @a.nodes.size.should == 10
    end
  end
  
  describe "Training" do
    before do
      @a = SOM.new(:nodes => 1, :dimensions => 2)
      @data = [[2,3]]
    end
    
    it "should change the weight of the best matching node" do
      before = @a.nodes.map {|x| x.weights.clone}
      @a.train(@data)
      after = @a.nodes.map {|x| x.weights}
      
      before.should_not == after
    end
    
    it "should will the nodes bucket with the data" do
      @a.train(@data)
      @a.nodes[0].bucket.should_not be_empty
    end
    
    it "should preserve data indexes" do
      data = [[0,0], [0,0.5], [2,4], [6,5]]
      @a.train(data)
      
      index_returned = @a.nodes[0].bucket[0][0]
      data_returned = @a.nodes[0].bucket[0][1]
      
      data[index_returned].should == data_returned
    end
  end
  
  describe "Inspect" do
    before do
      @a = SOM.new(:nodes => 1, :dimensions => 2)
      @data = [[2,3]]
    end
    
    it "should show the clusters of data indexes" do
      @a.train(@data)
      @a.inspect.should be_an(Array)
      @a.inspect.size.should == 1
    end
  end
  
  describe "Clustering" do
    before do
      @a = SOM.new(:nodes => 2, :dimensions => 2)
    end
    
    it "should belong to 2 seperate nodes" do
      data = [[0,0], [999,999]]
      @a.train(data)
      @a.inspect[0].should_not be_empty
      @a.inspect[1].should_not be_empty
    end
  end
  
  describe "Classify" do
    before do
      @a = SOM.new(:nodes => 2, :dimensions => 2)
    end
    
    it "should belong to 2 seperate nodes" do
      data = [[0,0], [999,999]]
      @a.train(data)
      @a.classify([1,1]).should be_an(Array)
      @a.classify([1,1]).size.should == 1
    end
  end
end
