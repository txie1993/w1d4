require 'byebug'

def range_iterative(start, stop)
  (start..stop).to_a
end

def range(start, stop)
  return [start] if start == stop
  return [] if stop < start
  [start] + range(start+1, stop)
end

def exp1(base, power)
  return 1 if power == 0
  exp1(base, power-1) * base
end

def exp2(base, power)
  return 1 if power == 0

  root = exp2(base, power/2)
  return root * root if power.even?

  lower_root = exp2(base, (power-1)/2)
  base * (lower_root * lower_root)
end

def fib_iterative(n)
  return [1] if n <= 1
  fib = [1, 1]
  while fib.length < n
    fib << fib[-2] + fib[-1]
  end
  fib
end

def fib_recursive(n)
  return [1] if n == 1
  return [1,1] if n == 2
  last = fib_recursive(n-1)
  last << last[-2] + last[-1]
end

def binary_search(array, target)
  # debugger
  return nil if (array.length <= 1 && array[0] != target)
  mid_idx = array.length/2
  return mid_idx if array[mid_idx] == target
  return binary_search(array[0...mid_idx], target) if target < array[mid_idx]
  mid_idx + 1 + binary_search(array[mid_idx+1..-1], target)
end

def merge_sort(array)
  return array if array.length <= 1
  left = array[0...array.length/2]
  right = array[array.length/2..-1]
  left = merge_sort(left)
  right = merge_sort(right)
  merge(left, right)

end

def merge(left, right)
  result = []
  left_idx = 0
  right_idx = 0

  while left_idx < left.length && right_idx < right.length
    if left[left_idx] < right[right_idx]
      result << left[left_idx]
      left_idx += 1
    else
      result << right[right_idx]
      right_idx += 1
    end
  end


  if left_idx == left.length
    result = result + right[right_idx..-1]
  else
    result = result + left[left_idx..-1]
  end

  result
end

class Array
  def deep_dup
    dup = Array.new()
    self.each do |el|
      if el.is_a?(Array)
        dup << el.deep_dup
      else
        dup << el
      end
    end
    dup
  end

  def subsets
    subs = [[]]

    self.each_index do |idx|
      removed = self.remove_at(idx)
      subs = subs + removed.subsets
    end

    subs << self
    subs.uniq.sort_by {|x| x.length}
  end

  def remove_at(idx)
    self[0...idx] + self[idx+1..-1]
  end
end

def greedy_make_change(amount, coins = [25, 10, 5, 1])
  change = []

  idx = 0
  while amount > 0
    biggest = amount/coins[idx]
    biggest.times do
      change << coins[idx]
      amount -= coins[idx]
    end
    idx += 1
    return nil if amount < coins.last
  end

  change
end

def recursive_make_change(amount, coins = [25, 10, 5, 1])
  coins = coins.sort.reverse
  return [] if amount == 0
  return nil if amount < coins.last

  shortest_seq = nil
  coins.each_with_index do |coin, idx|
    if coin <= amount
      remaining = amount - coin
      current = recursive_make_change(remaining, coins[idx..-1])
      next unless current
      current << coin
      if !shortest_seq || current.length < shortest_seq.length
        shortest_seq = current
      end
    end
  end
  shortest_seq
end

# => try every coin that when summed doesn't exceed the amount
# => call recursive_make_change for amount-coin for each coin
# => return the shortest array of those
