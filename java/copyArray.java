public class copyArray {
    public static void main(String[] args) {
        /* Creates a five element string array, creates a second array based upon the length of the first array, copy elements from first array to second, print elements of both arrays
        */

        // creating arrays
        String[] str1 = { "C++", "C", "Java", "Python", "JSON" };
        String str2[] = new String[str1.length];

        // copying array 1 to array 2
        for (int i = 0; i < str1.length; i++)
            {
                str2[i] = str1[i];
            }

        // Printing array 1
        System.out.println("Printing str1 array:");
        for (String s: str1)
            { 
                System.out.println(s);
            }
        // Printing array 2
        System.out.println("\nPrinting str2 array:"); 
        for (String s: str2)
            {
                System.out.println(s);
            }     
    }
}














