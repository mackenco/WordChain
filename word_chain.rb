require 'debugger'
require 'set'

def word_chain(start, finish)
  dictionary = load_dictionary('dictionary.txt')
  dictionary = filter_dict_by_length(dictionary, start.length)


end

def load_dictionary(dict_path)
  File.readlines(dict_path).map(&:chomp)
end

def filter_dict_by_length(dictionary, length)
  dictionary.select{ |word| word.length == length }
end

def adjacent_words(word, dictionary)
  regex_array = make_regex_array(word)
  word_list = []
  regex_array.each do |regex|
    word_list << filter_dict_by_regex(dictionary,regex)
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

if __FILE__ == $0
  # p word_chain('cat','got')
  # p word_chain('cat','ear')
  # p word_chain('cat','ton')
  #
  # p word_chain('duck','rank')
  # p word_chain('rank','dank')
  # p word_chain('dank','ruby')
  p word_chain('duck','lube')

end

