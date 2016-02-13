import java.io.PrintWriter;
import java.util.Scanner;
import java.io.IOException;
import java.io.File;
import java.nio.file.*;

public class DeleteAuthor {

    /**
     * @param args
     */
    public static void main(String[] args) {
        System.out.println("    java DeleteAuthor " + args[0] + " " + args[1]);
        Scanner in = null;
        PrintWriter writer = null;
        String file_name = "anon_" + args[1] + ".java";

        try {
            in = new Scanner( new File( args[0] ) );
            writer = new PrintWriter(file_name);
        } catch ( IOException e) {
            e.printStackTrace();
        }

        while(in.hasNextLine()){
            String text = in.nextLine();

            if( text.contains("@author") ){
                continue;
            }
            writer.write(text);
            writer.write("\n");
        }
        writer.close();
    }

}
