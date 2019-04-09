import java.util.Scanner;
public class ascii {
    public static void main(String[] args) { 

        /* Prints ascii values, takes user input, checks that input is a number and is between 32-127, converts number to character value.
        */

        // intialize variables
        Scanner input = new Scanner(System.in);
        int num = 0;
        boolean isValidNum = false;

        // printing characters as ascii values
        System.out.println("Printing characters A-Z as ASCII values:");
        for(char character = 'A'; character <= 'Z'; character++) {
            System.out.printf("Character %c has ascii value %d\n", character, ((int)character));
        }
        
        // printing ascii values as characters
        System.out.println("\nPrinting ASCII values 48-122 as characters:");
        for(num=48; num<=122; num++) {
            System.out.printf("ASCII value %d has character value %c\n", num, ((char)num));
        }

        // allow user input
        System.out.println("\nAllowing user ASCII value input:");

        while (isValidNum == false) {
            // check if input is a number
            System.out.print("Please enter ASCII value (32 - 127): ");
            if (input.hasNextInt()) {
                num = input.nextInt();
                isValidNum = true;
            }
            else {
                System.out.println("Invalid integer--ASCII value must be a number.");
            }
            input.nextLine(); // consumes line

            // check number is between 32 and 127
            if (isValidNum == true && num < 32 || num > 127) {
                System.out.println("ASCII value must be >= 32 and <= 127.\n");
                isValidNum = false;
            }
            if (isValidNum == true) {
                System.out.println();
                // display result
                System.out.printf("ASCII value %d has character value %c\n", num, ((char)num));
            }
        }

    }
}