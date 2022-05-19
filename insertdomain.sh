#!/bin/bash
# Written by the founder of Harrigan Code, a part of the Harrigan Group, on 2022.05.19
# Licence: you can use this script but you must retain any and all comments in any distribution.
# If implemented, you must include the full script file "as is" in the public repository of any project which executes it.
# Objective: script to substitue keyword in document for elements of web domain
# Syntax:
# insertdomain.sh [file] [page] [keyword] [targetdir] ![numberofrows]
# It just assumes you want 60 iterations. Pick another number if you want (or make a pull request putting args into a for {})

# Arguments
file=$1
template=$2
keyword=$3
targetdir=$4
# commented as not expanding properly
# numberofrows=$4

for i in {2..60} ; do j=$(./extractdomain.sh $file 1 8 - $i $i | awk '{print $1, $2}') ; cat $template| sed "s/$keyword/$j/" > $targetdir/$(echo $j | tr -d " " ).html; done

exit 0
