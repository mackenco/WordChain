require 'debugger'
require 'set'

def word_chain(start,finish, depth = 0, visited_words = Set.new)
  depth += 1
  dictionary = load_dictionary('dictionary.txt')
  dictionary = filter_dict_by_length(dictionary, start.length)
  intermediate = start

  on_the_path_words = []
  #visited_words = Set.new
  on_the_path_words << start
  visited_words << start
  off_by_one_words = adjacent_words(start,dictionary)
  off_by_one_words.reject! { |word| visited_words.include?(word) }



  while intermediate != finish
    target_words = make_target_words(start, finish)

    target_words.select! { |word| off_by_one_words.include?(word) }

    if target_words.length != 0
      p "success condition reached. depth: #{depth} word: #{start} visited_word_length: #{visited_words.length}"
      intermediate = target_words[0]
      if intermediate == finish
        p "OMG SUCCESS. depth: #{depth} word: #{start} visited_word_length: #{visited_words.length}"
        on_the_path_words << intermediate
      else
        on_the_path_words << word_chain(target_words[0],finish, depth, visited_words)
        on_the_path_words.flatten!.uniq!
        intermediate = on_the_path_words[-1]
      end
    else #fail condition
      p "fail condition reached. depth: #{depth} word: #{start} visited_word_length: #{visited_words.length}"
      intermediate_finish = nil
      visited_words = visited_words + off_by_one_words
      off_by_more_words = words_adjacent_to_visited_words(visited_words, dictionary)
      # debugger
      off_by_more_words.each do |word|
        temp_word_chain = word_chain(word, finish, depth, visited_words)
        if temp_word_chain[-1] == finish
          p "FOUND A PATH. depth: #{depth} word: #{start} visited_word_length: #{visited_words.length}"
          intermediate_finish = word
        end
      end
      if !intermediate_finish.nil?
        start_to_intermediate_finish = word_chain(start, intermediate_finish, depth, visited_words)
      end
      on_the_path_words << start_to_intermediate_finish
      on_the_path_words << temp_word_chain
    end

  end
  on_the_path_words
end

def load_dictionary(dict_path)
  File.readlines(dict_path).map(&:chomp)
end

def filter_dict_by_length(dictionary, length)
  dictionary.select{ |word| word.length == length }
end

def filter_dict_by_regex(dictionary, regex)
  dictionary.select{ |word| word.match(regex)}
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

def words_adjacent_to_visited_words(visited_words, dictionary)
  off_by_twos = []
  visited_words.each do |word|
    off_by_twos << adjacent_words(word,dictionary)
  end
  off_by_twos.flatten!.reject! {|word| visited_words.include?(word)}
  off_by_twos.uniq
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

def find_chain(start, finish, dictionary)
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
  # p word_chain('duck','ruby')

end

