require 'debugger'
require 'set'

class WordChain
  attr_accessor :dictionary

  def initialize(dictionary)
    @dictionary = load_dictionary(dictionary)
  end

  def find_chain(start, finish)
    @dictionary = filter_dict_by_length(start.length)

    current_words = [start]
    adjacents = []
    found = false
    paths = {[start] => nil }
    #paths[start] = nil
    visited_words = []

    until found
      found = false
      current_words.each do |word|
        next if visited_words.include?(word)
        visited_words << word
        adjacents = adjacent_words(word)

        if adjacents.include?(finish)
          found = true
          paths[finish] = word

        else

          adjacents.each do |adj|
              next if visited_words.include?(adj)
              word_in_two = adjacent_words(adj)
              if word_in_two.include?(finish)
                found = true
              end
            current_words << adj
            paths[adj] = word
          end

        end
      end
    end

    build_path(paths, finish)
  end

  def load_dictionary(dict_path)
    File.readlines(dict_path).map(&:chomp)
  end

  def filter_dict_by_length(length)
    @dictionary.select{ |word| word.length == length }
  end

  def filter_dict_by_regex(regex)
    @dictionary.select{ |word| word.match(regex)}
  end

  def adjacent_words(word)
    regex_array = make_regex_array(word)
    word_list = []
    regex_array.each do |regex|
      word_list << filter_dict_by_regex(regex)
    end
    word_list.flatten!.uniq!.delete(word)
    word_list
  end

  def make_regex_array(word)
    [].tap do |regex_arr|
      word.length.times do |letter_index|
        temp_word = word.dup
        temp_word[letter_index] = '.'
        regex_arr << Regexp.new(temp_word)
      end
    end
  end

  def build_path(paths, target)
    path = [target]
    until paths[target].nil?
      prev_word = paths[target]
      path << prev_word
      target = prev_word
    end
    path.reverse
  end
end


if __FILE__ == $0
  word_chain = WordChain.new('dictionary.txt')
  p word_chain.find_chain("duck", "ruby")
end

