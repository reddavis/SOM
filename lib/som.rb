require File.expand_path(File.dirname(__FILE__) + '/som/node')
require 'normalizer'

class SOM
  
  def initialize(training_data, options={})
    @training_data = training_data
    @number_of_nodes = options[:nodes] || 5
    @dimensions = options[:dimensions]
    @learning_rate = options[:learning_rate] || 0.5
    @radius = options[:radius] || @number_of_nodes / 2
    @iteration_count = 0
    @max_iterations = options[:max_iterations] || 500
    # TODO: Allow a lambda so we can use different neighborhood functions
    @neighborhood_function = options[:neighborhood_function] || 1
  end
  
  def nodes
    @nodes ||= []
  end
  
  def train
    create_nodes(@training_data)
    
    while train_it!(@training_data)
    end
    # Place the data in the nodes buckets so we can see how
    # The data has been clustered
    place_data_into_buckets(@training_data)
  end
  
  # Returns an array of buckets containing the index of the data given
  def inspect
    nodes.map {|x| x.bucket.map {|x| x[0]}}
  end
  
  # Return data from node that is closest to data
  # You are returned a bucket which contains arrays that look like:
  # [index, [data]]
  # The index is the original index of that that was pumped into the classifier
  # during the training process
  def classify(data)
    closest_node = find_closest_node(data)
    closest_node.bucket
  end
  
  private
  
  def train_it!(data)
    return false if @iteration_count >= @max_iterations
    
    data.each do |input|
      # Update closest node
      closest_node = find_closest_node(input)
      closest_node.update_weight(@learning_rate, input)
    
      # Update nodes that closer than the radius
      other_nodes = nodes - [closest_node]
      other_nodes.each do |node|
        next if @radius > node.distance_from(closest_node.weights)
      
        node.update_weight(@learning_rate, input, neighborhood_function)
      end
    end
    
    decrease_radius!
    decrease_learning_rate!
    increase_iteration_count!
  end
  
  def place_data_into_buckets(data)
    data.each_with_index do |input, index|
      closest_node = find_closest_node(input)
      closest_node << [index, input]
    end
  end
  
  def decrease_radius!
    @radius = 0.5 * @radius * @iteration_count / @max_iterations
  end
  
  def decrease_learning_rate!
    @learning_rate = 0.5 * @learning_rate * @iteration_count / @max_iterations
  end
  
  def increase_iteration_count!
    @iteration_count += 1
  end
  
  def neighborhood_function
    0.5 * @neighborhood_function * @iteration_count / @max_iterations
  end
  
  def find_closest_node(data)
    closest_node = [nodes[0], nodes[0].distance_from(data)]
    
    nodes[1..-1].each do |node|
      distance = node.distance_from(data)
      if distance < closest_node[1]
        closest_node = [node, distance]
      end
    end
    closest_node[0]
  end
  
  def create_nodes(data)
    max_weights = Normalizer.find_min_and_max(data)[1]
    @number_of_nodes.times { nodes << Node.new(@dimensions, max_weights) }
  end
  
end