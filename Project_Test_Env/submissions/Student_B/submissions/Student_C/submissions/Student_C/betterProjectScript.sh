#!/bin/bash
#
# Project X grading script.
# Grades only the student in the directory in which it is ran.
#
# Expected Directory Structure
# Project0X directory
#   - Script, test files, needed programs in the same folder as submissions
#   - submissions directory
#       - studentA
#            - student's files
#       - studentB 
#            - student's files
#       - studentC 
#            - student's files
#
# Prints output to multiple, descriptively named files
# in the student's directory, which will require manual inspection.
# vim or more work well towards this end.
#
# To Run:
# chmod +x .sh
# .sh

# Java runnable files
STUD_RUN=""
STUD_TEST_RUN=""
TA_TEST_1_RUN=""
TA_TEST_2_RUN=""

# all .java files that will have to be compiled
STUD_PROG_1=""
STUD_PROG_2=""
STUD_PROG_3=""
STUD_PROG_4=""
STUD_PROG_5=""
STUD_TEST_PROG=""

TA_TEST_1=""
TA_TEST_2=""
TA_TEST_3=""
TA_TEST_4=""
TA_TEST_5=""
TA_TEST_6=""

# Input Command Line Arguments
ARGS=""
INPUT_1=""
INPUT_2=""
INPUT_3=""
INPUT_4=""
INPUT_5=""
P6_STARTER_FOLDER=""

# File names for various outputs. "#" is used to place files together
STYLE_FILE="#STYLE.txt"
TS_TESTS="#TA_TESTS.txt"
ERROR="#COMPILATION_ERROR.txt"
OUTPUT="#OUTPUT.txt"

# Flag to check if the user force finishes a student
FLAG=0
GRADE_MANUALLY="../grade_manually.txt"
DIR=${PWD##*/}

function fail {
    echo >&2 $1; exit 1;
}

# This function should be called after every time a student file is ran.
# This function checks the return value and sees if it doesn't equal 0 or 1.
# If it doesn't equal then it informs the grader to check the student manually
# as results are not guranteed. It will then continue through the students files.
function finish {
    if [ $FLAG -eq 0 -o $FLAG -eq 1 ];
    then
        echo "    --->Finished $DIR" > /dev/tty; FLAG=0;
    else # if it was forced exited
        echo "" >> "$OUTPUT"
        echo "You CTRL-C the file. Inspect $DIR manually." >> "$OUTPUT"
        echo "  ---> You used CTRL-C to exit $DIR's program, check $DIR manually!" > /dev/tty; FLAG=0; break;
    fi
}

# Work on a student directory
function workOnDirectory {
    echo "Working on $DIR ..." > /dev/tty
    # Change the lines below if your directory structure does not match the one above.
    cp -n ../../*.java . # Copies over all .java files without overwriting anything that already exists
    cp -rf ../../$P6_STARTER_FOLDER . # Copies over starter folder folder with images for Project 6


    # Compiles all java files we just copied over
    ###############################################
    echo "    ... Compiling ..." > /dev/tty       #
    javac $STUD_PROG_1 2>> "$ERROR"               # Student Class/Student Programs
    javac $STUD_PROG_2 2>> "$ERROR"               #
    javac $STUD_PROG_3 2>> "$ERROR"               #
    javac $STUD_PROG_4 2>> "$ERROR"               #
    javac $STUD_PROG_5 2>> "$ERROR"               #
                                                  #
    javac $STUD_TEST_PROG 2>> "$ERROR"            # Student White Box
    javac $TA_TEST_1 2>> "$ERROR"                 # TS1 Test
    javac $TA_TEST_2 2>> "$ERROR"                 # TS2 Test
    javac $TA_TEST_3 2>> "$ERROR"                 # TS3 Test
    javac $TA_TEST_4 2>> "$ERROR"                 # TS4 Test
    javac $TA_TEST_5 2>> "$ERROR"                 # TS5 Tests
    ###############################################


    ################### Style. Change path if installed elsewhere ###################
    echo "    ... Working on Style ..." > /dev/tty                                  #
    echo "///////////////////////////////////////////////////////" >| "$STYLE_FILE" #
    echo "////////////////////////// STYLE //////////////////////" >> "$STYLE_FILE" #
    echo "///////////////////////////////////////////////////////" >> "$STYLE_FILE" #
    ~/cs/checkstyle $STUD_PROG_1 >>"$STYLE_FILE"                                    #
    echo "" >> "$TS_TESTS"                                                          #
    ~/cs/checkstyle $STUD_PROG_2 >>"$STYLE_FILE"                                    #
    echo "" >> "$TS_TESTS"                                                          #
    ~/cs/checkstyle $STUD_PROG_3 >>"$STYLE_FILE"                                    #
    echo "" >> "$TS_TESTS"                                                          #
    ~/cs/checkstyle $STUD_PROG_4 >>"$STYLE_FILE"                                    #
    #################################################################################


    ########################## Student Provided Test Cases ##########################
    echo "    ... Working on Student Test ..." > /dev/tty                           #
    echo "///////////////////////////////////////////////////////" >| "$TS_TESTS"   #
    echo "/////////////// Student WhiteBox Tests ////////////////" >> "$TS_TESTS"   #
    echo "///////////////////////////////////////////////////////" >> "$TS_TESTS"   #
    java $STUD_TEST_RUN >>"$TS_TESTS" 2>> "$TS_TESTS"                               #
    #################################################################################


    ########################### Teaching staff tests ################################
    echo "    ... Working on Teaching Staff Tests ..." > /dev/tty                   #
    echo "" >> "$TS_TESTS"                                                          #
    echo "///////////////////////////////////////////////////////" >> "$TS_TESTS"   #
    echo "//////////////////////// TS Test //////////////////////" >> "$TS_TESTS"   #
    echo "///////////////////////////////////////////////////////" >> "$TS_TESTS"   #
    java $TA_TEST_1_RUN >>"$TS_TESTS" 2>> "$TS_TESTS"                               #
    #java $TA_TEST_2_RUN >>"$TS_TESTS" 2>> "$TS_TESTS"                              #
                                                                                    #
    # IF THERE ARE MORE TEST CASES ADD THEM HERE. MIRROR THE FORMAT FOR TS1         #
                                                                                    #
                                                                                    #
    #################################################################################


    ############################### Output Section ##################################
    #echo "    ... Working on Output ..." > /dev/tty                                 #
    #echo "///////////////////////////////////////////////////////" >| "$OUTPUT"     #
    #echo "/////////////////////// Program Output ////////////////" >> "$OUTPUT"     #
    #echo "///////////////////////////////////////////////////////" >> "$OUTPUT"     #
    #java $STUD_RUN >> "$OUTPUT" 2>> "$OUTPUT"                                       #
    #trap finish EXIT                                                                #
                                                                                    #
    # IF THERE ARE MORE OUTPUT CASES ADD THEM HERE. MIRROR THE FORMAT ABOVE        #
                                                                                    #
    # Example with $Input_X piping                                                  #
    #   java $TA_TEST_RUN << $INPUT_1 >> "$OUTPUT" 2>> "$OUTPUT"                    #
                                                                                    #
                                                                                    #
    #################################################################################
    
    echo > /dev/tty
}


# Clean the terminal
clear

# Print welcome message
printf "**************************************************************************************\n"
printf "*   If a student's directory is taking too long to finish hit CTRL-C to skip them.   *\n"
printf "*     If you have to CTRL-C to skip a directory some files may not be completed.     *\n"
printf "*                      Be ready to check the student manually.                       *\n"
printf "*                                                                                    *\n"
printf "*                                ./script.sh submissions                             *\n"
printf "*                            ../../script.sh                                         *\n"
printf "*                                                                                    *\n"
printf "**************************************************************************************\n\n"

# Check if working on single directory (default) or a bunch of student directories
if [ $# -eq 0 ]; then 
    workOnDirectory
    printf "\nFinished $DIR\n"

# Work on a submission folder
else
    # Check if user supplied directory exists, fail if not
    if [ ! -d "$1" ]; then
        fail "Directory does not exist - Aborting script!"
    # Work through each submission
    else   
        printf "Looking through submission folder '$1'\n\n"
        #DIR=$1
        echo "-----STUDENTS TO GRADE MANUALLY-----" >| "$GRADE_MANUALLY"
        cd $1
        for DIR in *; do
        (
            cd ./$DIR
            workOnDirectory
        )
        done
    fi
        printf "\nFinished All Students\n"
fi