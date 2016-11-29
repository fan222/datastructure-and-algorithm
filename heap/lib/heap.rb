class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc || Proc.new{ |el1, el2| el1 <=> el2 }
  end

  def count
    store.length
  end

  def extract
    raise "no element to extract" if count == 0
    val = store[0]
    if count > 1
      store[0] = store.pop
      self.class.heapify_down(store, 0, &prc)
    else
      store.pop
    end
    val
  end

  def peek
    raise "no element to peek" if count == 0
    store[0]
  end

  def push(val)
    store << val
    self.class.heapify_up(store, self.count - 1, &prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    [2 * parent_index +1, 2 * parent_index +2].select { |idx| idx < len}
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    child_idx1, child_idx2 = child_indices(len, parent_idx)
    parent_val = array[parent_idx]
    children = []
    children << array[child_idx1] if child_idx1
    children << array[child_idx2] if child_idx2

    if children.all? { |child| prc.call(parent_val, child) <= 0 }
      return array
    end
    smallest_child_idx = nil
    if children.length == 1
      smallest_child_idx = child_idx1
    else
      smallest_child_idx =
        prc.call(children[0], children[1]) == -1 ? child_idx1 : child_idx2
    end
    array[parent_idx], array[smallest_child_idx] = array[smallest_child_idx], parent_val
    heapify_down(array, smallest_child_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    return array if child_idx == 0
    parent_idx = parent_index(child_idx)
    child_val, parent_val = array[child_idx], array[parent_idx]
    if prc.call(child_val, parent_val) >= 0
      return array
    else
      array[child_idx], array[parent_idx] = parent_val, child_val
      heapify_up(array, parent_idx, len, &prc)
    end
  end
end
