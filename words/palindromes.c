#include <stdio.h>
#include <string.h>
#include <ctype.h>

void trim(char *line)
{
    int new_line = strlen(line) -1;
    if (line[new_line] == '\n')
        line[new_line] = '\0';
}

void reverse(char *str)
{
    if (str == 0 || *str == 0)
    {
        return;
    }

    char *start = str;
    char *end = start + strlen(str) - 1; 
    char temp;

    while (end > start)
    {
        temp = *start;
        *start = *end;
        *end = temp;

        ++start;
        --end;
    }
}

int main()
{
    FILE* fp;
    char  line[50];
    fp = fopen("/u/b/r/brundin/words/words-unix", "r");
    while (fgets(line, sizeof(line), fp) != NULL)
    {
        trim(line);
        char word[50];
        strcpy(word, line);
        line[0] = tolower(line[0]);
        char backwards[50];
        strcpy(backwards, line);
        reverse(backwards);
        if ( strcmp(line,backwards) == 0 )
            printf("%s\n", word);
    }
}
