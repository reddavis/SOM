require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Som" do  
  describe "Training" do
    before do
      @data = [[0,0]]
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
            
      index_returned = @a.nodes[0].bucket[0]
      index_returned.should == 0
    end
  end
  
  describe "Inspect" do
    before do
      data = [[2,3]]
      @a = SOM.new(data, :nodes => 1)
      @a.train
    end
    
    it "should return the id of the nodes" do
      @a.inspect[0][0].should == 0
    end
    
    it "should show the clusters of data indexes" do
      @a.inspect[0][1].should be_an(Array)
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
      a = SOM.new(data, :nodes => 1)
      a.train
      @a = a.classify([1,1])
    end
    
    it "should belong to 2 seperate nodes" do
      @a.should be_an(Array)
      @a.size.should == 2
    end
    
    it "should return a node id" do
      @a[0].should == 0
    end
    
    it "should return an array of training_data ids" do
      @a[1].should be_an(Array)
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
  
  describe "Saving" do
    before do
      data = [[0,0], [999,999]]
      @a = SOM.new(data, :nodes => 5, :save_to => save_to_filepath)
    end
    
    it "should save the SOM where specified" do
      FileUtils.rm(save_to_filepath, :force => true)
      @a.train
      File.exists?(save_to_filepath).should be_true
    end
  end
  
  describe "Loading" do
    before do |variable|
      data = [[0,0], [999,999]]
      a = SOM.new(data, :nodes => 5, :save_to => save_to_filepath)
      a.train
    end
    
    it "should have 5 nodes" do
      a = SOM.load(save_to_filepath)
      a.nodes.size.should == 5
    end
  end
  
  private
  
  def save_to_filepath
    File.expand_path(File.dirname(__FILE__) + '/db/som.som')
  end
end
