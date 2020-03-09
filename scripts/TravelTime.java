import java.util.Scanner;

public class TravelTime {
    public static void main (String [] args) {

        Scanner input = new Scanner (System.in);

        double miles = 0.0;
        double mph = 0.0;
        double hours = 0.0;
        Boolean isValidMiles = false;
        Boolean isValidMPH = false;

        System.out.println("Program calculates approximate travel time.");

        int minutes = 0;
        int hoursInt = 0;
        String choice = "";

        do {
            while (isValidMiles == false) {
                System.out.print("Please enter miles: "); 
                if (input.hasNextDouble()) {
                    miles = input.nextDouble();
                    isValidMiles = true;
                } else {
                    System.out.println("Invalid double--miles must be a number.\n");
                }
                input.nextLine();
                if (isValidMiles == true && miles <= 0 || miles > 3000) {
                    System.out.println("Miles must be greater than 0, and no more than 3000.\n");
                    isValidMiles = false;
                } else if (isValidMiles == true && isValidMPH == false) {
                    while (isValidMPH == false) {
                        System.out.print("Please enter MPH: ");
                        if (input.hasNextDouble()) {
                            mph = input.nextDouble();
                            isValidMPH = true;
                        } else {
                            System.out.println("Invalid double--MPH must be a number\n");
                            isValidMPH = false;
                        }
                        input.nextLine();
                        if (isValidMPH == true && mph <= 0 || mph > 100) {
                            System.out.println("MPH must be greater than 0, and no more than 100.\n");
                            isValidMPH = false;
                        }
                    }
                }
                if (isValidMiles == true && isValidMPH == true) {
                    System.out.println();
                    hours = miles / mph;

                    minutes = (int) (hours * 60);
                    hoursInt = minutes / 60;
                    minutes = minutes % 60;

                    System.out.println("Estimated travel time: " + hoursInt + " hr(s) " + minutes + " Minutes");
                }
            }
            isValidMiles = false;
            isValidMPH = false;

            System.out.print("\nContinue? (y/n): ");
            choice = input.next();
            System.out.println();
        }
        while (choice.equalsIgnoreCase("y"));
    }
}