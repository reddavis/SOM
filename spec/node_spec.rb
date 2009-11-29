require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Node" do
  describe "Initialization" do
    before do
      @a = Node.new(5)
    end
    
    it "should have 5 weights" do
      @a.weights.size.should == 5
    end
  end
  
  describe "Distance Calculation" do
    before do
      @a = Node.new(2)
      @b = Node.new(2)
    end
    
    it "should return 0" do
      @a.weights[0] = @b.weights[0]
      @a.weights[1] = @b.weights[1]
      @a.distance_from(@b.weights).should == 0
    end
    
    it "should return 1" do
      @b.weights[0] = 0.0
      @b.weights[1] = 0.0
      
      @a.weights[0] = 1.0
      @a.weights[1] = 0.0
      
      @a.distance_from(@b.weights).should == 1
    end
  end
  
  describe "Update Weight" do
    describe "Closest" do
      before do
        @a = Node.new(2)
        @data = [1,2]
      end
    
      it "should change the weight" do
        before = @a.weights.clone
        @a.update_weight(0.5, @data)
        @a.weights.should_not == before
      end
    end
    
    describe "Neighbor" do
      before do
        @a = Node.new(2)
        @data = [1,2]
      end
    
      it "should change the weight" do
        before = @a.weights.clone
        @a.update_weight(0.5, @data, 0.23)
        @a.weights.should_not == before
      end
    end
  end
  
  describe "Bucket" do
    before do
      @a = Node.new(2)
    end
    
    it "should put data into the nodes bucket" do
      @a << 'some_data'
      @a.bucket.size.should == 1
    end
  end
end
