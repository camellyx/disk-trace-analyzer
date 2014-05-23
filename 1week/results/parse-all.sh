#!/usr/bin/env bash

mkdir -p write-interval retention
for file in *.stdout
do
  echo "retention_in_day,read_interval_in_day,count" > retention/${file%.stdout}.csv
  ../scripts/parse-hash.pl $file ret >> retention/${file%.stdout}.csv
  echo "write_interval_in_hour,count" > write-interval/${file%.stdout}.csv
  ../scripts/parse-hash.pl $file wri >> write-interval/${file%.stdout}.csv
done

../scripts/merge-retention.pl
