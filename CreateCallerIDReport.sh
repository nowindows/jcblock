#!/bin/sh

# This shell script generates a callerID.report from a callerID file passed as argument
# The call count for each call number and callerID is listed, sorted by frequency
#
# Usage: ./CreateCallerIDReport.sh callerId.dat
# 
# The script assumes chronological entries andthe following format for call entry
# YYYY-MM-DDThh:mm|callnumber|callerid_string|
#2014-01-21T11:25|1|Unavailable |

> callerID.Report
firstDate=$(head -n1 $1 | cut -c-10)
lastDate=$(tail -n1 $1 | cut -c-10)
echo "Report By Call Frequency for $1 from $firstDate through $lastDate" >> callerID.Report

> callerNumber
echo "\n  Count   Number" > callerNumber
cut -f2 -d'|' $1 | sort | uniq -c | sort -b -r -n -t' ' >> callerNumber

> callerID
echo "\n  Count   CallerID" > callerID
cut -f3 -d'|' $1 | sort | uniq -c | sort -b -r -n -t' '  >> callerID

> callers
paste callerNumber callerID  | gawk '{ FS="\t"} ; {printf "%-22s                      %-22s\n", $1, $2}' > callers

cat callers >> callerID.Report
rm callerNumber
rm callerID
rm callers
cat callerID.Report