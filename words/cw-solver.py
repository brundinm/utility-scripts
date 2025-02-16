def getDictionary():
    dictionaryOpen = open('words-unix','r')
    dictionary = dictionaryOpen.read().split()
    dictionaryOpen.close()
    return dictionary
    

def checkWord (testWord,dictionary):
    
    nonBlanks = len(testWord)-testWord.count(' ')
    for word in dictionary:
        incLetter = 0
        incMatch = 0
        if len (word) == len (testWord):
            for letter in testWord:

#### These lines commented out as we improved the code later.
#### They have been left here for reference.
##                if letter == ' ':
##                    incLetter += 1
##                elif letter == word[incLetter]:
##                    incLetter +=1
##                    incMatch +=1
##                else:
##                    incLetter += 1

                if letter == word[incLetter]:
                    incMatch += 1
                incLetter += 1
            if incMatch == nonBlanks:
                print (word)
    return
        
testWord = raw_input ('Please input a word to solve.\nUse Spaces to signify unknown letters: ').lower()


dictionary = getDictionary()
checkWord (testWord,dictionary)
    
