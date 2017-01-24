#!/bin/bash
#
# /afs/eos.ncsu.edu/courses/csc/csc116/common/private/2016-Spring/2016_Spring_P4_Grading
#
# Project 6 looping grading script.
# Grades all students in the submissions directory
#
# The script expects the following directory structure:
# Project 6 directory
#   - Script, test files, needed programs in the same folder as submissions
#   - grade_manually.txt (this will be generated for you)
#   - submissions directory <-- Run ../p6_loop.sh IN this directory
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
# chmod +x p6_loop.sh
# ../p6_loop.sh

# Java runnable files
STUD_RUN=""
STUD_TEST_RUN="MatchGameTest"
TA_TEST_1_RUN="TestSummary"
TA_TEST_2_RUN=""

# all .java files that will have to be compiled
STUD_PROG_1="Card.java"
STUD_PROG_2="Deck.java"
STUD_PROG_3="Grid.java"
STUD_PROG_4="MatchGame.java"
STUD_PROG_5="MatchGameGUI.java"
STUD_TEST_PROG="MatchGameTest.java"

TA_TEST_1="CardTSTest.java"
TA_TEST_2="DeckTSTest.java"
TA_TEST_3="GridTSTest.java"
TA_TEST_4="MatchGameTSTest.java"
TA_TEST_5="TestSummary.java"
TA_TEST_6="StaffAcceptanceTests.java"

# Input Command Line Arguments/Piping
ARGS=""
INPUT_1=""
INPUT_2=""
INPUT_3=""
INPUT_4=""
INPUT_5=""
P6_STARTER_FOLDER="cards"

# File names for various outputs. "#" is used to place files together
STYLE_FILE="#STYLE.txt"
TS_TESTS="#TA_TESTS.txt"
ERROR="#COMPILATION_ERROR.txt"
OUTPUT="#OUTPUT.txt"

GRADE_MANUALLY="../grade_manually.txt"
FLAG=0

function finish {
    if [ $FLAG -eq 0 -o $FLAG -eq 1 ];
    then
        echo "    --->Finished $DIR" > /dev/tty; FLAG=0; continue;
    else
        echo "" >> "$WS_OUTPUT"
        echo "You CTRL-C the file. Check $DIR manually." >> "$WS_OUTPUT"
        echo "$DIR" >> "../$GRADE_MANUALLY"
        echo "  ---> You used CTRL-C to exit $DIR's program, check $DIR manually!" > /dev/tty; FLAG=0; break;
    fi
}

printf "**************************************************************************************\n"
printf "*   If a student's directory is taking too long to finish hit CTRL-C to skip them.   *\n"
printf "*   This will create a grade_manually.txt in the directory above the Submissions.    *\n"
printf "*   The grade_manually.txt will list all students you will have to check manually.   *\n"
printf "**************************************************************************************\n\n"

echo "-----STUDENTS TO GRADE MANUALLY-----" >| "$GRADE_MANUALLY"

for DIR in *; do
(
    cd ./$DIR
    echo "Working on $DIR" > /dev/tty

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
    echo "////////////////////////// STYLE //////////////////////" >> "$STYLE_FILE"  #
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
    #java $TA_TEST_2_RUN >>"$TS_TESTS" 2>> "$TS_TESTS"                               #
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
    # IF THERE ARE MORE OUTPUT CASES ADD THEM HERE. MIRROR THE FORMAT ABOVE          #
                                                                                     #
    # Example with $Input_X piping                                                   #
    #   java $TA_TEST_RUN << $INPUT_1 >> "$OUTPUT" 2>> "$OUTPUT"                     #
                                                                                     #
                                                                                     #
    #################################################################################

)
done

echo "Finished All Students" > /dev/tty
