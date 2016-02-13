import java.io.PrintWriter;
import java.util.Scanner;
import java.io.IOException;
import java.io.File;
import java.nio.file.*;

/**
 * FileOperations handles restructuring a folder as well as
 * ensuring student data is anonymous.
 * @author Thomas Ortiz tdortiz@ncsu.edu (Anonymous Scripting)
 * @author Zach Butler zcbutler@ncsu.edu (Rename Scripting)
 */
public class FileOperations {

    /** The Submissions directory or specified directory by user */
    private static String Submissions;
    /** Anon Folder where anonymousized files will go */
    private static File Anon_Submissions;

    public static void main(String[] args) {
        Submissions = args.length > 0 ? args[0] : "Submissions";
        Scanner input = new Scanner(System.in);

        while(true){
            System.out.println();
            System.out.println("         What would you like to do?");
            System.out.println("Enter (R)ename/Reorganize to re-organize a <Submissions> folder.");
            System.out.println("Enter (A)nonymizer");
            System.out.println("Enter (Q)uit to quit.");

            String in = input.nextLine().toUpperCase();
            if(in.charAt(0) == 'R'){
                renameSubmissions(Submissions);
            } else if( in.charAt(0) == 'A'){
                Anon_Submissions = new File("Anon_Submissions");
                Anon_Submissions.mkdir(); // Creates Anon_Sub... in the same directory as DeleteAuthors.java
                                          // This will house all of our new anon submissions
                anon();
            } else {
                break;
            }
        }
        input.close();
    }

    /**
     * Restructure a folder called <Submissions> by creating student directories
     * and placing student files in their respective directory.
     * @param folderName to restructure
     */
    public static void renameSubmissions(String folderName){
        File folder = new File(folderName);
        File[] allFiles = folder.listFiles(); // Array of User Folders (StudentA, StudentB, StudentC)

        for (File f : allFiles) {
            String moodleFileName = f.getName();
            String studentName = moodleFileName.substring(0, moodleFileName.indexOf("_")).replaceAll(" ", "_");
            String actualFileName = moodleFileName.substring(moodleFileName.indexOf("_file_") + 6);
            File studentFolder = new File(folderName + "/" + studentName);
            if (!studentFolder.exists()) {
                studentFolder.mkdir();
            }
            if (renameFile(f, folderName, studentName, actualFileName)) {
                System.out.printf("Renamed %s to %s\n", moodleFileName, actualFileName);
            } else {
                System.out.printf("FAILED to rename %s to %s\n", moodleFileName, actualFileName);
            }
        }
    }

    /**
     * Renames the file based off of the students name
     * @param  f          [description]
     * @param  folderName [description]
     * @param  heirarchy  [description]
     * @param  newName    [description]
     * @return            [description]
     */
    private static boolean renameFile(File f, String folderName, String heirarchy, String newName) {
        if (f.renameTo(new File(folderName + "/" + heirarchy + "/" + newName))) {
            return true;
        } else {
            try {
                Files.move(Paths.get(folderName + "/" + f.getName()),
                    Paths.get(folderName + "/" + heirarchy + "/" + newName));
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    /**
     * Takes in a string that represents the extension of a file. Then
     * the method navigates through each file in the directory and
     * gets rid of all files that have the extension.
     * @param ext of files to get rid of
     */
    public static void getRidOfFiles(File dir, String ext) {
        File[] allFiles = dir.listFiles();

        for (File f : allFiles) {
            String name = f.getName();
            int idx = name.lastIndexOf(".");
            if (idx == -1) {
                if (ext.equals("")) {
                    f.delete();
                }
            } else {
                if (ext.equals(name.substring(idx + 1))) {
                    f.delete();
                }
            }
        }
    }

    /**
     * Pre: Assumes use of the above rename algorithm.
     * Clears the @author tag of all files and creates a file into a new anonymous directory in Anon_Submissions
     * Post: Creates Anon_Submissions folder in same directory as FileOperations.java
     */
    public static void anon(){
        File folders = new File(Submissions); // The <Submissions> directory
        File[] studentFolders = folders.listFiles(); // Array of each student direction in <Submissions>

        // For each Student Folder in the Submissions directory
        for(File f : studentFolders){
	        System.out.println("I am in " + f.getName() + " Directory");
            getRidOfFiles(f.getAbsoluteFile(), "class");
            File[] student_Files = f.listFiles();



            // For each file in the students directory
            for( File fsub : student_Files ){
                // Create a directory in our Anon_Submissions directory to house student files
                File anon_Student_Dir = new File(Anon_Submissions, "anon_" + f.getName());  /** Thomas change this file to anon the name */
                anon_Student_Dir.mkdir();

                System.out.println("    I am messing with " + fsub.getName());
                Scanner in = null;
                PrintWriter writer = null;
                String file_name = "anon_" + fsub.getName(); // the new file name

                // Creates a new file anon_<old file name.ext>
                try {
                    in = new Scanner( fsub );
                    writer = new PrintWriter( new File(anon_Student_Dir.getAbsolutePath(), file_name) );
                } catch ( IOException e) {
                    e.printStackTrace();
                }

                // Parses through file copying over old contents to a new anon file
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
    }
}
