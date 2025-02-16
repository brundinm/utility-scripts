import sys

oldsig = ""

def squash(line):
        global oldsig
        sig=line.partition(" ")[0]
        word=line.partition(" ")[2][:-1] #remove carriage return
        #print "sig=",sig,"word=",word, "oldsig=", oldsig
        if sig == oldsig:
          print word,
        else :
          oldsig=sig
          print "\n",oldsig, word,

if __name__ == "__main__":
  #for line in sys.stdin.readlines():
  for line in open(sys.args[1],'r'):
        squash(line)
