/**
 * This class will print out a Ascii Art Penguin from 
 * http://www.ascii-art.de/ascii/my/small4.shtml
 * @author Thomas Ortiz
 */
public class Art {

    /**
     * Starts the program.
     * @param args command line arguments
     */
    public static void main(String[] args) {
        drawHead();
        drawNeck();
        drawBelly();
        drawFeet();
        System.out.println();
    }
    
    /**
     * Draws the head of the penguin.
     */
    public static void drawHead() {
       	System.out.println("        a8888b.");
       	System.out.println("       d888888b.");
       	System.out.println("       8P\"YP\"Y88");
        System.out.println("       8|o||o|88");
        System.out.println("       8'    .88");
        System.out.println("       8`._.' Y8.");
    }
    
    /**
     * Draws the neck of the penguin.
     */
    public static void drawNeck() {
        System.out.println("      d/      `8b.");
        System.out.println("    .dP   .     Y8b.");
    }
    
    /**
     * Draws the belly of the penguin.
     */
    public static void drawBelly() {
        System.out.println("   d8:'   \"   `::88b.");
        System.out.println("  d8\"           `Y88b");
        System.out.println(" :8P     '        :888");
        System.out.println("  8a.    :       _a88P");
    }
    
    /**
     * Draws the feet of the penguin. 
     */ 
    public static void drawFeet() {
        System.out.println("._/\"Yaa_ :     .| 88P|");
        System.out.println("\\    YP\"       `| 8P  `.");
        System.out.println("/     \\._____.d|    .'");
        System.out.println("`--..__)888888{`._.'");
	}
}	
