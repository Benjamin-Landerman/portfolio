import java.util.Scanner;
public class countCharacters {
    public static void main(String[] args) {

        /* Accepts input and counts number and types of characters (letters, spaces, numbers, and other characters)
        */

        // initializing variables
        Scanner input = new Scanner (System.in);

        String test = "";
        int letter = 0;
        int space = 0;
        int digit = 0;
        int other = 0;

        // allowing input
        System.out.println("Please enter string: ");
        test = input.nextLine();

        // counting number and types of characters
        for (int i = 0; i < test.length(); i++) {
            if (Character.isLetter(test.charAt(i))) {
               letter++;
            } else if (Character.isSpaceChar(test.charAt(i))) {
               space++;
            } else if (Character.isDigit(test.charAt(i))) {
               digit++;
            } else {
                other++;
            }
        }

        // printing results
        System.out.println("Your string: \"" + test + "\" has the following number and types of characters:");
        System.out.println("letter(s): " + letter);
        System.out.println("space(s): " + space);
        System.out.println("number(s): " + digit);
        System.out.println("other characters(s): " + other);           
    }
}

