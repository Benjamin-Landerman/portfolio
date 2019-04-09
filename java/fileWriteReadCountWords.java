import java.util.Scanner;
import java.io.IOException;
import java.io.PrintWriter;
public class fileWriteReadCountWords {
    public static void main(String[] args) throws IOException {
        
        /* Accepts input, writes to and reads from same file, and conts numbers of words in the file
        */

        // initializing variables
        Scanner input = new Scanner (System.in);
        int wordCount = 0;

        // accepting input
        System.out.println("Please enter text: ");

        String text = input.nextLine();

        // writing input to file "filecountwords.txt"
        PrintWriter writer = new PrintWriter("filecountwords.txt", "UTF-8");
        writer.println(text);
        writer.close();

        // printing confirmation
        System.out.println("Saved to file \"filecountwords.txt\"");

        // counting words in file
        String[] words = text.split(" ");
        wordCount = wordCount + words.length;

        // printing results
        System.out.println("Number of words: " + wordCount);
    }
}