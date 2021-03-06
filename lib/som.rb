require File.expand_path(File.dirname(__FILE__) + '/som/node')

class SOM
  
  class << self
    def load(db_filepath)
      data = ""
      File.open(db_filepath) do |f|
        while line = f.gets
          data << line
        end
      end
      Marshal.load(data)
    end
  end
  
  def initialize(training_data, options={})
    @training_data = training_data
    @dimensions = training_data[0].size
    @iteration_count = 1
    
    # Options
    @number_of_nodes = options[:nodes] || 5
    @learning_rate = options[:learning_rate] || 0.7
    @radius = options[:radius] || @number_of_nodes / 2
    @max_iterations = options[:max_iterations] || 100
    @db_filepath = options[:save_to]
    
    # TODO: Allow a lambda so we can use different neighborhood functions
    @neighborhood_function = 1 #options[:neighborhood_function] || 1
    @verbose = options[:verbose]
    
    create_nodes(training_data)
  end
  
  def nodes
    @nodes ||= []
  end
  
  def train
    while train_it!(@training_data)
    end
    # Place the data in the nodes buckets so we can see how
    # The data has been clustered
    place_data_into_buckets(@training_data)
    save
  end
  
  # Returns an array of buckets containing the index of the training data
  def inspect
    nodes.map {|x| [x.id, x.bucket] }
  end
  
  # Return training data from the node that is closest to input data
  # You are returned an array that look like:
  # [node_id, [training_data_index_1, training_data_index_2...]]
  # The index is the original index of that that was pumped into the SOM
  # during the training process
  def classify(data)
    closest_node = find_closest_node(data)
    [closest_node.id, closest_node.bucket]
  end
  
  # Taken from AI4R SOM library #107
  def global_distance_error
    @training_data.inject(0) do |sum, n|
      sum + find_closest_node_with_distance(n)[1]
    end
  end
  
  private
  
  def save
    if @db_filepath
      File.open(@db_filepath, "w+") do |f|
        f.write Marshal.dump(self)
      end
    end
  end
  
  def train_it!(data)
    return false if @iteration_count >= @max_iterations
    
    print_message("Iteration: #{@iteration_count}")
        
    data.each_with_index do |input, index|
      print_message("\tLooking at data #{index+1}/#{data.size}")
      
      # Update closest node
      print_message("\t\tUpdating closest node")
      
      closest_node = find_closest_node(input)
      closest_node.update_weight(@learning_rate, input)
    
      # Update nodes that closer than the radius
      other_nodes = nodes - [closest_node]
      other_nodes.each_with_index do |node, index|
        distance_from_node = node.distance_from(closest_node.weights)
        print_message("\t\tDistance from node: #{distance_from_node}")
        
        next if distance_from_node > decayed_radius
        
        print_message("\t\t\tUpdating other nodes: #{index+1}/#{other_nodes.size}")
        
        node.update_weight(@learning_rate, input, neighborhood_function)
      end
    end
    
    increase_iteration_count!
  end
  
  # This places the training data into its closest node's bucket.
  def place_data_into_buckets(data)
    data.each_with_index do |input, index|
      closest_node = find_closest_node(input)
      closest_node << index
    end
  end
  
  def decayed_radius
    @radius - (0.7 * @radius * @iteration_count / @max_iterations)
  end
  
  def decayed_learning_rate
    @learning_rate - (0.7 * @learning_rate * @iteration_count / @max_iterations)
  end
    
  def neighborhood_function
    0.5 * @neighborhood_function * @iteration_count / @max_iterations
  end
  
  def increase_iteration_count!
    @iteration_count += 1
  end
  
  def find_closest_node(data)
    find_closest_node_with_distance(data)[0]
  end
  
  # Finds the closest node to some data and returns the node
  # and its distance from the data => [node, distance]
  def find_closest_node_with_distance(data)
    closest_node = [nodes[0], nodes[0].distance_from(data)]
    
    nodes[1..-1].each do |node|
      distance = node.distance_from(data)
      if distance < closest_node[1]
        closest_node = [node, distance]
      end
    end
    closest_node
  end
  
  def create_nodes(data)
    @number_of_nodes.times do |n|
      nodes << Node.new(n, @dimensions)
    end
  end
  
  def print_message(message)
    puts message if @verbose == true
  end
  
end