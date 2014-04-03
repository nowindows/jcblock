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
grep -v '^#' callerID.dat | sed 's/,/;/g' | awk '{gsub(/--DATE = |--TIME|--NAME|--NMBR/,"")}1' \
| sed 's/ \= /,/g' | sed 's/--//g' | sed 's/^\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1,\2,\3/g'\
| sed 's/,\([0-9]\{2\}\)\([0-9]\{2\}\),/,\1,\2,/g' \
| awk ' { FS=","} ; {printf "20%s-%s-%sT%s:%s|%s|%s|\n", $3, $1, $2 , $4, $5, $6, $7}' | sed 's/;/,/g' > callerID.dat.new

# the blacklist.dat file
grep -v '^#' blacklist.dat | cut -c1-19 > CID
grep -v '^#' blacklist.dat | cut -c20-21 > Cm
grep -v '^#' blacklist.dat | cut -c22-23 > Cd
grep -v '^#' blacklist.dat | cut -c24-25 > Cyr
grep -v '^#' blacklist.dat | cut -c34- > CComment

paste -d"|" CID Cyr Cm Cd CComment |  awk ' { FS="|"} ; {printf "%s|20%s-%s-%sT12:00|%s|\n", $1, $2, $3, $4, $5}' > blacklist.dat.new
rm CID Cm Cd Cyr CComment

# the whitelist.dat file
grep -v '^#' whitelist.dat | cut -c1-19 > CID
grep -v '^#' whitelist.dat | cut -c20-21 > Cm
grep -v '^#' whitelist.dat | cut -c22-23 > Cd
grep -v '^#' whitelist.dat | cut -c24-25 > Cyr
grep -v '^#' whitelist.dat | cut -c34- > CComment

paste -d"|" CID Cyr Cm Cd CComment |  awk ' { FS="|"} ; {printf "%s|20%s-%s-%sT12:00|%s|\n", $1, $2, $3, $4, $5}' > whitelist.dat.new
rm CID Cm Cd Cyr CComment


