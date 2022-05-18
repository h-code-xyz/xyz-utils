#!/bin/bash
# Written by the founder of Harrigan Code, a part of the Harrigan Group, on 2022.05.18
# Licence: you can use this script but you must retain any and all comments in any distribution.
# If implemented, you must include the full script file "as is" in the public repository of any project which executes it.
# Objective: script to extract elements of web domain from csv
# Syntax:
# extractdomain.sh [file] [targetcolumn] [most common length of first word] [delimiter] [startrow] [endrow]
# Example:
# Eile: domains.txt
# web-site.com,otherjunkdata,morejunkdata
# webpage-name.com,otherjunkdata,morejunkdata
# website-title.net,somuch,junk,data
# yougettheidea.com,spam,eggs,spam
#
# IN << extractdomain.sh domains.txt 7 - 2 3
# OUT >> Webpage Name com
# OUT >> Website Title net
#
# Can be used in equivalent manor for *@*.* format addresses e.g. email:
# email@address.com becomes Email Address Com

# Arguments
file=$1
column=$2
len0=$3
delim=$4
start=$5
end=$6

# Pick up target data as block of $allDomains
allDomains=$(cat $file | sed -n 2,$(echo $(wc -l <(cat $file)) | awk '{print $1}')p | cut -d , -f 1)


# Associative arrays for formatted target data
# Each "doma.in" is separated from block and split into "Na Me"."tld"
declare domain=()
declare name=()
declare tld=()

# Need to number them to produce ${domain[fromrow]}, ${name[fromrow]} and ${tld[fromrow]}
count=0
for i in $allDomains ; do count=$( echo $(( $count+1)) ) ; domain[$count]=$i ;

# Trying to make sure prefix is before delimiter in case delimiter is sooner than $len0 (arg 3)
j=$(echo $i | cut -d "$delim" -f 1 | cut -d . -f 1 );

# web
prefix=${j:0:$len0} ;

k=$(echo ${i:$len0:$(expr length $i)} | cut -d "$delim" -f 2 | cut -d . -f 1 ) ;

# site
suffix=$(echo $k | sed "0,/${k:0:1}/s// \U${k:0:1}/") ;

# com
tld[$count]=$(echo $i | cut -d . -f 2);

# Web Site
name[$count]=$(echo $(echo ${prefix:0:$len0} | sed "0,/${i:0:1}/s//\U${i:0:1}/") $suffix) ; done ;

# The following line results in output for each row in range start (arg 5) to end (arg 6): Web Site com
echo "$(for i in {0..58}; do echo ${name[$i]} ${tld[$i]}; done)" | sed -n ${start},${end}p
exit 0
