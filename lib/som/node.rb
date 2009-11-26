class Node
  
  attr_reader :bucket
  
  def initialize(number_of_weights)
    create_weights(number_of_weights)
    @bucket = []
  end
  
  def weights
    @weights ||= []
  end
  
  def update_weight(learning_rate, inputs, neighborhood_function=1)
    weights.each_with_index do |weight, index|
      @weights[index] += learning_rate * neighborhood_function * (inputs[index] - weight)
    end
  end
  
  # A bucket is a place to put the data that is closest to it
  def <<(data)
    @bucket << data
  end
  
  # Euclidean Distance
  def distance_from(data_points)
    distance = 0
    data_points.each_with_index do |point, index|
      distance += (point - weights[index]) ** 2
    end
    Math.sqrt(distance)
  end
  
  private
  
  def create_weights(number_of_weights)
    number_of_weights.times do
      weights << (rand > 0.5 ? -rand : rand)
    end
  end
  
end