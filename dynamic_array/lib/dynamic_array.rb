require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
  end

  # O(1)
  def [](index)
    validate!(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    validate!(index)
    @store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" unless (length > 0)
    val, self[length - 1] = self[length - 1], nil
    @length -= 1
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity

    @length += 1
    self[length - 1] = val
    nil
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" unless (length > 0)

    val = self[0]
    (1...@length).each {|i| self[i - 1] = self[i]}
    @length -= 1
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @capacity == @length

    self.length += 1
    (length - 2).downto(0).each {|i| @store[i+1] = @store[i]}
    self[0] = val
    nil
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_capacity = @capacity * 2
    new_store = StaticArray.new(new_capacity)
    length.times { |i| new_store[i] = self[i] }

    @capacity = new_capacity
    @store = new_store
  end

  def validate!(index)
    raise "index out of bounds" unless (index >= 0) && (index < @length)
  end
end
