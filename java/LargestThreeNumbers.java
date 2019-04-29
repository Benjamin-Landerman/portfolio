import java.util.Scanner;
import java.lang.Math;
public class LargestThreeNumbers {
    public static void main(String[] args) {

        // program accepts input, checks that values are integers, and calculates largest number
        System.out.println("Program evaluates largest of three integers.");
        System.out.println("Note: Program checks for integers and non-numberic values.");

        // initializing variables
        Scanner input = new Scanner(System.in);
        int num1 = 0;
        int num2 = 0;
        int num3 = 0;
        boolean isValidNum = false;
        boolean isValidNum2 = false;
        boolean isValidNum3 = false;

        // accepting input
        System.out.println("Please enter first number: ");

        // checking for valid integer
        while (isValidNum == false) {
            if (input.hasNextInt()) {
                num1 = input.nextInt();
                isValidNum = true;
            }
            else {
                System.out.println("Not a valid integer!");
                System.out.println("Please try again. Enter first number: ");
            }
            input.nextLine(); // consumes line
        }

        System.out.println("Please enter second number: ");

        // checking for valid integer
        while (isValidNum2 == false) {
            if (input.hasNextInt()) {
                num2 = input.nextInt();
                isValidNum2 = true;
            }
            else {
                System.out.println("Not a valid integer!");
                System.out.println("Please try again. Enter second number: ");
            }
            input.nextLine(); // consumes line
        }

        // checking for valid integer
        System.out.println("Please enter third number: ");

        while (isValidNum3 == false) {
            if (input.hasNextInt()) {
                num3 = input.nextInt();
                isValidNum3 = true;
            }
            else {
                System.out.println("Not a valid integer!");
                System.out.println("Please try again. Enter third number: ");
            }
            input.nextLine(); // consumes line
        }

        // calculating largest of three numbers and printing result
        if (num1 > num2 && num1 > num3) {
            System.out.println("First number is largest.");
        }
        else if (num2 > num1 && num2 > num3) {
            System.out.println("Second number is largest.");
        }
        else {
            System.out.println("Third number is largest.");
        }
    }
}