import string
import sys

def sign(file):
  for w in open(file,'r'):
        sig=list(w[:-1]) # remove carriage return
        sig.sort()
        print string.join(sig,""), w[:-1]

if __name__ == "__main__":
  sign(sys.argv[1])

