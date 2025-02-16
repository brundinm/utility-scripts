File.foreach("/u/b/r/brundin/words/words-unix") { |word|
  word.chomp!
  forwards = word.downcase
  if forwards == forwards.reverse
     puts word
  end
}
