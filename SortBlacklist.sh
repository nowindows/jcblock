#!/bin/bash

# SortBlacklist.sh sorts the .blacklist.dat file by the Date field
# so that most recent date is first

#now sort using:
# -r reverse order
# -t"|" | as field separator
# -k2.2.2.10 by second field first column to second field 10th column
cat blacklist.dat | sort -r -t"|" -k2.1,2.10 > blacklist.dat.new

# total lines in file
lines=$(cat blacklist.dat.new | wc -l)
echo "$lines Lines sorted by datestamp > blacklist.dat.new"
