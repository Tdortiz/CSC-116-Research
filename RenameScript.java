import java.io.*;
import java.nio.file.*;

/**
 * Rename the moodle downloaded files to their original filenames
 *
 * @author Zach Butler zcbutler@ncsu.edu
 * @author Thomas Ortiz tdortiz@ncsu.edu
 * @precondition Java 1.8 or greater is installed
 */
public class RenameScript {
    /**
     * Run the script to rename the files
     * Make sure the unzipped submissions folder is at the same level as this file
     *
     * @param args string of command line arguments, first being folder name (default: Submissions)
     */
    public static void main(String[] args) {
        String folderName = args.length > 0 ? args[0] : "Submissions"; // If there is an arg file name use that, otherwise use Submissions as default
        
        File folder = new File(folderName);
        getRidOfFiles(folder, "html");      // TODO Replace with whatever file extension you want gone
        File[] allFiles = folder.listFiles();
        
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
}
