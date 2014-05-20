#!/usr/bin/env bash

mkdir -p write-interval retention
for file in *.stdout
do
  echo "retention_in_hour,count" > retention/${file%.stdout}.csv
  ../scripts/parse-hash.pl $file ret | sort -t',' -n -k 1 >> retention/${file%.stdout}.csv
  echo "write_interval_in_hour,count" > write-interval/${file%.stdout}.csv
  ../scripts/parse-hash.pl $file wri | sort -t',' -n -k 1 >> write-interval/${file%.stdout}.csv
done
