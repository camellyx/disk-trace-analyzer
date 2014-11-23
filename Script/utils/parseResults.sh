#!/usr/bin/env bash

for conf in results/*; do
  grep "Number of cleans:" $conf/*.outv | sort -t- -k2,2 -k3,3 -n -k4,4 -k5,5 -k6,6 -k7,7 > $conf/cleans.txt
  grep "iozone" $conf/cleans.txt > $conf/cleans.iozone.txt
  grep "postmark" $conf/cleans.txt > $conf/cleans.postmark.txt

  grep "ssd Response time average:" $conf/*.outv | grep -v "#" | sort -t- -k2,2 -n -k4,4 -k5,5 > $conf/responseTime.txt
  grep "iozone" $conf/responseTime.txt | cut -f 3 -d ':'  > $conf/responseTime.iozone.txt
  grep "postmark" $conf/responseTime.txt | cut -f 3 -d ':' > $conf/responseTime.postmark.txt

  grep "@@@" $conf/*.outv | grep -v "#" | sort -t- -k2,2 -n -k4,4 -k5,5 > $conf/healthHotCold.txt

  grep "iozone" $conf/healthHotCold.txt > $conf/healthHotCold.iozone.txt
  grep "window" $conf/healthHotCold.iozone.txt | grep "Hot healthy:" > $conf/window.iozone.txt
  grep "prob-promote" $conf/healthHotCold.iozone.txt | grep "Hot healthy" > $conf/prob-promote.iozone.txt
  grep "ori" $conf/healthHotCold.iozone.txt | grep "Hot healthy" > $conf/ori.iozone.txt
  grep "Hot healthy:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/hotHealthy.iozone.txt
  grep "Hot unhealth:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/hotUnhealth.iozone.txt
  grep "Cold healthy:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/coldHealthy.iozone.txt
  grep "Cold unhealth:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/coldUnhealth.iozone.txt
  grep "Hot write:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/hotWrite.iozone.txt
  grep "Cold write:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/coldWrite.iozone.txt
  grep "Hot clean:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/hotClean.iozone.txt
  grep "Cold clean:" $conf/healthHotCold.iozone.txt | cut -f 3 -d ':' > $conf/@@@_iozone/coldClean.iozone.txt
  cut -f 3 -d '-' $conf/window.iozone.txt > $conf/@@@_iozone/w_policy.txt
  cut -f 4 -d '-' $conf/window.iozone.txt > $conf/@@@_iozone/w_overProvisioning.txt
  cut -f 5 -d '-' $conf/window.iozone.txt | cut -f 1 -d '.' > $conf/@@@_iozone/w_hotPoolSize.txt
  cut -f 9 -d '-' $conf/window.iozone.txt > $conf/@@@_iozone/w_bit.txt

  cut -f 4,5 -d '-' $conf/prob-promote.iozone.txt > $conf/@@@_iozone/pp_policy.txt
  cut -f 6 -d '-' $conf/prob-promote.iozone.txt > $conf/@@@_iozone/pp_overProvisioning.txt
  cut -f 7 -d '-' $conf/prob-promote.iozone.txt > $conf/@@@_iozone/pp_hotPoolSize.txt
  cut -f 8 -d '-' $conf/prob-promote.iozone.txt | cut -f 1 -d '.' > $conf/@@@_iozone/pp_bit.txt

  cut -f 3 -d '-' $conf/ori.iozone.txt > $conf/@@@_iozone/ori_policy.txt
  cut -f 4 -d '-' $conf/ori.iozone.txt | cut -f 1 -d '.' > $conf/@@@_iozone/ori_overProvisioning.txt
  cut -f 9 -d '-' $conf/ori.iozone.txt > $conf/@@@_iozone/ori_hotPoolSize.txt
  cut -f 9 -d '-' $conf/ori.iozone.txt > $conf/@@@_iozone/ori_bit.txt

  for path in results/window/@@@_iozone; do
      paste -d "," $path/w_policy.txt $path/w_overProvisioning.txt $path/w_hotPoolSize.txt $path/w_bit.txt $path/../responseTime.iozone.txt $path/*.iozone.txt > window.iozone.csv
  done
  for path in results/prob-promote/@@@_iozone; do
      paste -d "," $path/pp_policy.txt $path/pp_overProvisioning.txt $path/pp_hotPoolSize.txt $path/pp_bit.txt $path/../responseTime.iozone.txt $path/*.iozone.txt > prob-promote.iozone.csv
  done
  for path in results/ori/@@@_iozone; do
      paste -d "," $path/ori_policy.txt $path/ori_overProvisioning.txt $path/ori_hotPoolSize.txt $path/ori_bit.txt $path/../responseTime.iozone.txt $path/*.iozone.txt > ori.iozone.csv
  done


  grep "postmark" $conf/healthHotCold.txt > $conf/healthHotCold.postmark.txt
  grep "window" $conf/healthHotCold.iozone.txt | grep "Hot healthy:"  > $conf/pm_window.iozone.txt
  grep "prob-promote" $conf/healthHotCold.iozone.txt | grep "Hot healthy:" > $conf/pm_prob-promote.iozone.txt
  grep "ori" $conf/healthHotCold.iozone.txt | grep "Hot healthy:" > $conf/pm_ori.iozone.txt
  grep "Hot healthy:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/hotHealthy.postmark.txt
  grep "Hot unhealth:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/hotUnhealth.postmark.txt
  grep "Cold healthy:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/coldHealthy.postmark.txt
  grep "Cold unhealth:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/coldUnhealth.postmark.txt
  grep "Hot write:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/hotWrite.postmark.txt
  grep "Cold write:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/coldWrite.postmark.txt
  grep "Hot clean:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/hotClean.postmark.txt
  grep "Cold clean:" $conf/healthHotCold.postmark.txt | cut -f 3 -d ':' > $conf/@@@_postmark/coldClean.postmark.txt
  cut -f 3 -d '-' $conf/pm_window.iozone.txt > $conf/@@@_postmark/w_policy.pm.txt
  cut -f 4 -d '-' $conf/pm_window.iozone.txt > $conf/@@@_postmark/w_overProvisioning.pm.txt
  cut -f 5 -d '-' $conf/pm_window.iozone.txt | cut -f 1 -d '.' > $conf/@@@_postmark/w_hotPoolSize.pm.txt
  cut -f 9 -d '-' $conf/pm_window.iozone.txt > $conf/@@@_postmark/w_bit.pm.txt

  cut -f 4,5 -d '-' $conf/pm_prob-promote.iozone.txt > $conf/@@@_postmark/pp_policy.pm.txt
  cut -f 6 -d '-' $conf/pm_prob-promote.iozone.txt > $conf/@@@_postmark/pp_overProvisioning.pm.txt
  cut -f 7 -d '-' $conf/pm_prob-promote.iozone.txt > $conf/@@@_postmark/pp_hotPoolSize.pm.txt
  cut -f 8 -d '-' $conf/pm_prob-promote.iozone.txt | cut -f 1 -d '.' > $conf/@@@_postmark/pp_bit.pm.txt

  cut -f 3 -d '-' $conf/pm_ori.iozone.txt > $conf/@@@_postmark/ori_policy.pm.txt
  cut -f 4 -d '-' $conf/pm_ori.iozone.txt | cut -f 1 -d '.' > $conf/@@@_postmark/ori_overProvisioning.pm.txt
  cut -f 9 -d '-' $conf/pm_ori.iozone.txt > $conf/@@@_postmark/ori_hotPoolSize.pm.txt
  cut -f 9 -d '-' $conf/pm_ori.iozone.txt > $conf/@@@_postmark/ori_bit.pm.txt

  for path in results/window/@@@_postmark; do
      paste -d "," $path/w_policy.pm.txt $path/w_overProvisioning.pm.txt $path/w_hotPoolSize.pm.txt $path/w_bit.pm.txt $path/../responseTime.postmark.txt $path/*.postmark.txt > window.postmark.csv
  done
  for path in results/prob-promote/@@@_postmark; do
      paste -d "," $path/pp_policy.pm.txt $path/pp_overProvisioning.pm.txt $path/pp_hotPoolSize.pm.txt $path/pp_bit.pm.txt $path/../responseTime.postmark.txt $path/*.postmark.txt > prob-promote.postmark.csv
  done
  for path in results/ori/@@@_postmark; do
      paste -d "," $path/ori_policy.pm.txt $path/ori_overProvisioning.pm.txt $path/ori_hotPoolSize.pm.txt $path/ori_bit.pm.txt $path/../responseTime.postmark.txt $path/*.postmark.txt > ori.postmark.csv
  done

  cat  *.iozone.csv *.postmark.csv > output.csv

done
