# Programmer: Mihalis Tsoukalos
# Date: Monday 20 April 2015

# MRB: See https://www.gadgetdaily.xyz/finding-anagrams-with-mihalis-tsoukalos/
# and https://github.com/mactsouk/LUD/tree/master/CC154

# Found in the "Effective AWK Programming, 4th ed." book.
function signature( word )
{
    n = split(word, a, "")
    asort(a)
    
    for (i = 1; i<=n; i++)
    {
        result = result a[i]
    }
    return result
}

# Each line must have one word only
{
    result = ""
    printf("The signature of %s is %s\n", $1, signature($1))
}
