#!/bin/sh

# This shell script used grep, sed, and awk to convert "old format" callerID.dat
# whitelist.dat, and blacklist.dat files to the new format.
#
# Only non commented lines are processed. Commas within the callerID string are retained
# The call number and caller ID string lengths are retained by using | to delimit the
# call time, call number, and caller ID strings.  The character case is retained.

# The first line of each file is not converted correctly and must be fixed.
# This needs debugging.

# first the callerID.dat file
grep -v '^#' callerID.dat | sed 's/,/;/g' | sed 's/--DATE = \([0-9]\{4\}\)/\1,/g' | awk '{gsub(/--TIME|--NAME|--NMBR/,"")}1' | sed 's/ \= /,/g' | sed 's/--//g' | awk ' { FS=","} ; {printf "20%s%sT%s|%s|%s|\n", $2, $1 , $3, $5, $4}' | sed 's/;/,/g' > callerID.dat.new

# the blacklist.dat file
grep -v '^#' blacklist.dat | cut -c1-19 > CID
grep -v '^#' blacklist.dat | cut -c20-23 > Cmd
grep -v '^#' blacklist.dat | cut -c24-25 > Cyr
grep -v '^#' blacklist.dat | cut -c34- > CComment

paste -d"|" CID Cyr Cmd CComment |  awk ' { FS="|"} ; {printf "%s|20%s%sT1200|%s|\n", $1, $2, $3, $4}' > blacklist.dat.new
rm CID Cmd Cyr CComment

# the whitelist.dat file
grep -v '^#' whitelist.dat | cut -c1-19 > CID
grep -v '^#' whitelist.dat | cut -c20-23 > Cmd
grep -v '^#' whitelist.dat | cut -c24-25 > Cyr
grep -v '^#' whitelist.dat | cut -c34- > CComment

paste -d"|" CID Cyr Cmd CComment |  awk ' { FS="|"} ; {printf "%s|20%s%sT1200|%s|\n", $1, $2, $3, $4}' > whitelist.dat.new
rm CID Cmd Cyr CComment


