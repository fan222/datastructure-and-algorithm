class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    empty? ? nil : @head.next
  end

  def last
    empty? ? nil : @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    each do |link|
      return link.val if link.key == key
    end
    nil
  end

  def include?(key)
    any? { |link| link.key == key }
  end

  def insert(key, val)
    each do |link|
      if link.key == key
        link.val = val
        return link
      end
    end

    append(key, val)
  end


  def remove(key)
    each do |link|
      if link.key == key
        link.prev.next = link.next
        link.next.prev = link.prev
        link.next = nil
        link.prev = nil
        return link
      end
    end
    nil
  end

  def append(key, val)
    new_link = Link.new(key, val)

    @tail.prev.next = new_link
    new_link.prev = @tail.prev
    new_link.next = @tail
    @tail.prev = new_link

    new_link
  end

  def each(&prc)
    current_link = @head.next
    until current_link == @tail
      prc.call(current_link)
      current_link = current_link.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
