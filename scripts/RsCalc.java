import java.util.Scanner;
public class rsCalc {
    public static void main(String[] args) {

        // Program for calculating skills and experience in Old School Runescape game. Accepts input for skill, calculates skill level based on experience, accepts input for target level, calculates experience until target and percentage of the way there based on current experience.

        //ABCXYZ
        Scanner input = new Scanner(System.in);
        Boolean complete = false;
        String skill = "";
        int exp = 0;
        int level = 0;
        int target = 0;
        int targetExp = 0;
        int expDiff = 0;
        double percentCalc = 0.0;
        double percent = 0.0;
        String yn = "";

        while (complete == false) {
            Boolean isValidSkill = false;
            Boolean isValidExp = false;
            Boolean isValidTarget = false;
            Boolean isValidYn = false;
            
            // accepting input, checking for valid skill, assigning input to skill
            while (isValidSkill == false) {
                System.out.println("Please enter a skill: ");
                skill = input.nextLine();
                skill = skill.substring(0,1).toUpperCase() + skill.substring(1).toLowerCase();

                if (skill.equals("Agility")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Construction")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Cooking")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Crafting")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Farming")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Firemaking")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Fishing")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Fletching")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Herblore")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Hunter")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Mining")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Prayer")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Runecrafting")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Smithing")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Slayer")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Thieving")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else if (skill.equals("Woodcutting")) {
                    System.out.println("\nYou've selected " + skill + ".");
                    isValidSkill = true;
                }
                else {
                    System.out.println("\nInvalid skill!");
                }
            }
            
            // accepting exp value, checking for valid input
            System.out.println("\nEnter your current experience points in " + skill + ":");
            while (isValidExp == false) {
                // checking for int
                if (input.hasNextInt()) {
                    exp = input.nextInt();
                    isValidExp = true;
                }
                else {
                    System.out.println("\nInvalid experience points.\nValue must be a number between 0 and 200,000,000. Try again: ");
                }
                input.nextLine();
                // checking value range
                if (isValidExp == true && exp < 0 || exp > 200000000) {
                    System.out.println("\nInvalid experience points.\nValue must be a number between 0 and 200,000,000. Try again: ");
                    isValidExp = false;
                }
            }

            // array of levels; values from: https://oldschoolrunescape.fandom.com/wiki/Experience
            int increments[] = {
                0, 0, 83, 174, 276, 388, 512, 650, 801, 969, 1154, 1358, 1584, 1833, 2107, 2411, 2746, 3115, 3523, 3973,
                4470, 5018, 5624, 6291, 7028, 7842, 8740, 9730, 10824, 12031, 13363, 14833, 16456, 18247, 20224, 22406,
                24815, 27473, 30408, 33648, 37224, 41171, 45529, 50339, 55649, 61512, 67983, 75127, 83014, 91721, 101333,
                111945, 123660, 136594, 150872, 166636, 184040, 203254, 224466, 247886, 273742, 302288, 333804, 368599,
                407015, 449428, 496254, 547953, 605032, 668051, 737627, 814445, 899257, 992895, 1096278, 1210421, 1336443,
                1475581, 1629200, 1798808, 1986068, 2192818, 2421087, 2673114, 2951373, 3258594, 3597792, 3972294, 4385776,
                4842295, 5346332, 5902831, 6517253, 7195629, 7944614, 8771558, 9684577, 10692629, 11805606, 13034431, 200000001
            };

            // goes through array indexes to find level
            for (level = 0; level < increments.length; level++) {
                if (increments[level + 1] > exp)
                    break;
            }       

            System.out.println("\nYour " + skill + " level = " + level);

            // checking for integer and that target level is greater than current level
            while (isValidTarget == false) {
                System.out.println("\nEnter your target " + skill + " level: ");
                // checking for int
                if (input.hasNextInt()) {
                    target = input.nextInt();
                    isValidTarget = true;
                }
                else {
                    System.out.println("Invalid level. Please enter an integer!");
                }
                input.nextLine();
                
                // gets target experience value from array
                targetExp = increments[target];
                // calculates experience needed for target level
                expDiff = targetExp - exp;

                // checking target level is greater than target level and is valid level (1-99)
                if (isValidTarget == true) {
                    if (expDiff < 0) {
                        System.out.println("You've already passed level " + target + " " + skill + "!");
                        isValidTarget = false;
                    }
                    else if (target <= 1 || target >= 100) {
                        System.out.println("Invalid level. Please enter an integer between 2 and 99!");
                        isValidTarget = false;
                    }
                }
                if (isValidTarget == true) {
                    // converting exp and targetExp to doubles for percentage calculation
                    double e = exp;
                    double t = targetExp;

                    // percentage calculation
                    percentCalc = e / t;
                    percent = percentCalc * 100;
   
                    // printing results with formatting
                    System.out.println("\nYou have " + expDiff + " experience points remaining until level " + target + " " + skill + ".");
                    System.out.print("You are ");
                    System.out.printf("%.2f", percent);
                    System.out.println("% of the way to level " + target + " " + skill + ".");
                }
            }

            // allowing for additional skill input
            System.out.println("\nType \"yes\" if you would like to enter another skill or type \"no\" to end the program: ");
            isValidYn = false;
            while (isValidYn == false) {
                yn = input.nextLine();
                if (yn.equalsIgnoreCase("yes")) {
                    complete = false;
                    isValidYn = true;
                }
                else if (yn.equalsIgnoreCase("no")) {
                    complete = true;
                    isValidYn = true;
                }
                else {
                    System.out.println("Invalid input. Enter \"yes\" or \"no\": ");
                    isValidYn = false;
                }
            }
        }
    }
}