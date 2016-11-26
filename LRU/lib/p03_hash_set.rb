require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    return false if include?(key)
    resize! if @count == num_buckets
    self[key].push(key)
    @count += 1
    key
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    self[key].delete(key)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    num_hash = num.hash
    @store[num_hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    data = @store
    @store = Array.new(num_buckets * 2) { Array.new }
    @count = 0
    data.flatten.each {|num| insert(num)}
  end
end
