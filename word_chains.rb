require 'set'
class WordChains
  def initialize(dictionary_file_name = "dictionary.txt")
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(@dictionary)
  end

  def adjacent_words(word)
    adjacent_words = []
    word.each_char.with_index do |old_letter, i|
      ('a'..'z').each do |new_letter|
        next if old_letter == new_letter

        new_word = word.dup
        new_word[i] = new_letter

        adjacent_words << new_word if @dictionary.include?(new_word)
      end
    end

    adjacent_words
  end

  # def words_with_length(len)
  #   sub_dictionary = @dictionary.select {|word| word.length == len}
  #   Set.new(sub_dictionary)
  # end

  def distance(src, target)
    return nil if src.length != target.length
    src = src.split('')
    target = target.split('')
    d = 0
    src.each_with_index do |char, idx|
      d+=1 unless char == target[idx]
    end
    d
  end

  def run(src, target)
    return nil if src.length != target.length
    #sub_dictionary = words_with_length(src.length)
    @current_words = [src]
    @all_seen_words = {src => nil}
    until @current_words.empty?
      @current_words = explore_current_words(target)#, sub_dictionary)
    end
    puts build_path(target)
  end

  def explore_current_words(target)#, sub_dictionary)
    new_current_words = []
    @current_words.each do |current|
      #closest_words(current, target, sub_dictionary).each do |adj|
      adjacent_words(current).each do |adj|
         next if @all_seen_words.has_key?(adj)
         new_current_words << adj
         @all_seen_words[adj] = current
         return [] if adj == target
      end
    end
    new_current_words
  end


  def build_path(target)
    current = target
    path = []
    while current
      path << current
      current = @all_seen_words[current]
    end
    path.reverse
  end

  def closest_words(src, target, dictionary)
    d = distance(src, target)
    words = dictionary.select { |word| distance(target, word) <= d  && distance(src, word) == 1 }
    Set.new(words)
  end
end

if __FILE__ == $0
  word_chains = WordChains.new("dictionary.txt")
end
