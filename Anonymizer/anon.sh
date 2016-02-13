#!/bin/bash
#
# To Run:
# chmod +x p1_loop.sh
# ../p1_loop.sh

for DIR in *; do
(

    cd ./$DIR
    echo "Working on $DIR" > /dev/tty

    cp ../../*.java .

    javac DeleteAuthor.java

    java DeleteAuthor AreaComparison.java
)
done

echo "Finished All Students" > /dev/tty
