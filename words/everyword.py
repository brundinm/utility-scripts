import string
import sys
import itertools

substrings = []

def findsubsets(S,m):
  return itertools.combinations(S,m)

def everyword(input):
  global substring
  li=list(input)
  for i in range(3,(len(li)+1),1):
        for ss in findsubsets(li,i):
          ssl=list(ss)
          ssl.sort()
          substring=string.join(ssl,"")
          if substring not in substrings:
                substrings.append(substring)
  for s in substrings:
        print s


if __name__ == "__main__":
  everyword(sys.argv[1])
