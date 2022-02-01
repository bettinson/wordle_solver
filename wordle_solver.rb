require "Set"
require './words.rb'

def main
  included_words = Words.included_words
  words = []

  included_words.each do |word|
    word = word.strip
    if word.length == 5
      words << word.downcase
    end
  end

  frequencies = letter_frequencies(words)

  word_scores = Hash.new(0)


  # USAGE
  # guess the top word (arose usually)
  # if there are grey letters, add them to the array
  grey_letters = []
  # if there are green letters, place them in the array (has to be in the 5 char array)
  green_letters = ['', '', '', '', '']
  # if there are yellow letters, add them to the array
  yellow_letters_arrays = []

  loop do 
    words.each do |word|
      word_scores[word] = score_word(word, frequencies, grey_letters, green_letters, yellow_letters_arrays)
    end
  
    sorted_scores = word_scores.sort_by {|k, v| v}
    values = sorted_scores.map {|score| score[0]}
    puts "Your best guesses to start off are:"
    p values.last(10).reverse

    puts "add to the grey letters: #{grey_letters} \n"
    new_grey_letters = gets.chomp
    grey_letters << new_grey_letters.split(//)
    grey_letters.flatten!
    p grey_letters

    puts "change the yellow letters (_ for empty): #{yellow_letters_arrays} \n"
    new_yellow_letters = gets.chomp

    new_yellow_letters = new_yellow_letters.split(//)
    yellow_letters_arrays << new_yellow_letters.map { |x| x == '_' ? '' : x }
    p yellow_letters_arrays

    puts "change the green letters (_ for empty): #{green_letters} \n"
    new_green_letters = gets.chomp

    green_letters = new_green_letters.split(//)
    green_letters = green_letters.map { |x| x == '_' ? '' : x }
    p green_letters
  end
end

def letter_frequencies(words)
  freq = Hash.new(0)

  words.each do |word|
    word.split(//).each do |c|
      freq[c] = freq[c] + 1
    end
  end

  return freq
end

def unique_characters(word)
  Set.new(word.split(//)).length
end

def matches_green_letters?(word, green_letters)
  (word.length).times do |i|
    if green_letters[i] != '' && green_letters[i] != word[i]
      return false
    end
  end
  return true
end

def matches_yellow_letters?(word, yellow_letters_arrays)
  yellow_letters_arrays.each do |yellow_letters_array|
    (word.length).times do |i|
      if yellow_letters_array[i] != '' && yellow_letters_array[i] == word[i]
        return false
      end
    end
  end
  return true
end

def score_word(word, letter_frequency, grey_letters, green_letters, yellow_letters_arrays)
  score = 0
  word.split(//).each do |c|
    return 0 if grey_letters.include?(c) || !matches_green_letters?(word, green_letters) || !matches_yellow_letters?(word, yellow_letters_arrays)
    score += letter_frequency[c]
  end

  score = score * unique_characters(word)

  return score
end

main