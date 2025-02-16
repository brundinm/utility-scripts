import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
 
class Palindromes
{
  public static void main(String args[]) throws IOException 
  {
    File file = new File("/u/b/r/brundin/words/words-unix");
    FileReader fr = new FileReader(file);
    BufferedReader br = new BufferedReader(fr);
    String word;
    while((word = br.readLine()) != null){
      String forwards = word.toLowerCase();
      String backwards = new StringBuffer(forwards).reverse().toString();
      if (forwards.equals(backwards))
        System.out.println(String.format("%s", forwards));
    }
    br.close();
    fr.close();
  }
}
