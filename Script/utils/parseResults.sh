#!/usr/bin/env bash

for conf in results/*; do
  grep "ssd Response time average:" $conf/*.outv | grep -v "#" | sort -t- -k2,2 -n -k4,4 -k5,5 > $conf/responseTime.txt
  grep "iozone" $conf/responseTime.txt > $conf/responseTime.iozone.txt
  grep "postmark" $conf/responseTime.txt > $conf/responseTime.postmark.txt
  grep "Number of cleans:" $conf/*.outv | sort -t- -k2,2 -k3,3 -n -k4,4 -k5,5 -k6,6 -k7,7 > $conf/cleans.txt
  grep "iozone" $conf/cleans.txt > $conf/cleans.iozone.txt
  grep "postmark" $conf/cleans.txt > $conf/cleans.postmark.txt
done
