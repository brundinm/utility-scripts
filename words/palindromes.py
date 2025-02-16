words = open('/u/b/r/brundin/words/words-unix', 'r').read().split()
for word in words:
  forwards = word.lower()
  if forwards == forwards[::-1]:
    print word

