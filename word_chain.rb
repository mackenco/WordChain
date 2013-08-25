require 'debugger'
require 'set'

class WordChain
  attr_accessor :dictionary

  def initialize(dictionary)
    @dictionary = load_dictionary(dictionary)
  end

  def word_chain(start, finish)
    @dictionary = filter_dict_by_length(start.length)

    current_words = [start]
    adjacent_words = []

    #current_words.each do |word| end

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

  def make_target_words(start, finish)
    [].tap do |target_words|
      start.length.times do |index|
        temp_start = start.dup
        temp_start[index] = finish[index]
        target_words << temp_start
      end
    end.uniq.reject{|word| word == start}
  end
end


if __FILE__ == $0
  word_chain = WordChain.new('dictionary.txt')
  p word_chain.make_regex_array("word")
end

