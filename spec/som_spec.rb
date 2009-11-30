require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Som" do  
  describe "Training" do
    before do
      @data = [[0,0], [0,0.5], [2,4], [6,5]]
      @a = SOM.new(@data, :nodes => 1)
    end
    
    it "should change the weight of the best matching node" do
      before = @a.nodes.map {|x| x.weights.clone}
      @a.train
      after = @a.nodes.map {|x| x.weights}
      
      before.should_not == after
    end
    
    it "should fill the nodes bucket with the data" do
      @a.train
      @a.nodes[0].bucket.should_not be_empty
    end
    
    it "should preserve data indexes" do
      @a.train
      
      index_returned = @a.nodes[0].bucket[0][0]
      data_returned = @a.nodes[0].bucket[0][1]
      
      @data[index_returned].should == data_returned
    end
  end
  
  describe "Inspect" do
    before do
      data = [[2,3]]
      @a = SOM.new(data, :nodes => 1)
    end
    
    it "should show the clusters of data indexes" do
      @a.train
      @a.inspect.should be_an(Array)
      @a.inspect.size.should == 1
    end
  end
  
  describe "Clustering" do
    before do
      data = [[0,0], [999,999]]
      @a = SOM.new(data, :nodes => 2)
    end
    
    it "should belong to 2 seperate nodes" do
      @a.train
      @a.inspect[0].should_not be_empty
      @a.inspect[1].should_not be_empty
    end
  end
  
  describe "Classify" do
    before do
      data = [[0,0], [999,999]]
      @a = SOM.new(data, :nodes => 2)
    end
    
    it "should belong to 2 seperate nodes" do
      @a.train
      @a.classify([1,1]).should be_an(Array)
      @a.classify([1,1]).size.should == 1
    end
  end
  
  describe "Global Distance Error" do
    before do
      data = [[0,0], [999,999]]
      @a = SOM.new(data, :nodes => 2)
    end
    
    it "should return an integer" do
      @a.global_distance_error.should be_a(Float)
    end
  end
end
