#!/usr/bin/env bash

POLICIES=(window dynwindow prob-promote ori)
BENCHMARKS=(iozone postmark financial1 financial2 websearch1 websearch2 homes webvm hm_0 mds_0 prn_0 proj_0 prxy_0 rsrch_0 src1_0 stg_0 ts_0 usr_0 wdev_0 web_0 cello1)

if [ "$1" == "" ]; then
  echo "please input a input folder name"
  exit
fi

for conf in $1/*; do
##  grep "Number of cleans:" $conf/*.outv | sort -t- -k2,2 -k3,3 -n -k4,4 -k5,5 -k6,6 -k7,7 > $conf/cleans.txt
##  grep "iozone" $conf/cleans.txt > $conf/cleans.iozone.txt
##  grep "postmark" $conf/cleans.txt > $conf/cleans.postmark.txt
#
  grep "ssd Response time average:" $conf/*.outv | grep -v "#" | sort -t- -k2,2 -n -k4,4 -k5,5 > $conf/responseTime.txt
  for benchmark in ${BENCHMARKS[@]}; do
    grep "$benchmark" $conf/responseTime.txt | cut -f 3 -d ':' > $conf/$benchmark.responseTime.txt
  done

#  grep "iozone" $conf/responseTime.txt | cut -f 3 -d ':'  > $conf/iozone.responseTime.txt
#  grep "postmark" $conf/responseTime.txt | cut -f 3 -d ':' > $conf/postmark.responseTime.txt
#
  grep "@@@" $conf/*.outv | grep -v "#" | sort -t- -k2,2 -n -k4,4 -k5,5 > $conf/healthHotCold.txt
done


    for policy in ${POLICIES[@]}; do
        for benchmark in ${BENCHMARKS[@]}; do
            grep $benchmark $1/$policy/healthHotCold.txt > $1/$policy/$benchmark.healthHotCold.txt
            grep "Hot healthy:" $1/$policy/$benchmark.healthHotCold.txt > $1/$policy/$benchmark.types.txt
            grep "Hot healthy:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/hotHealthy.$benchmark.txt
            grep "Hot unhealth:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/hotUnhealth.$benchmark.txt
            grep "Cold healthy:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/coldHealthy.$benchmark.txt
            grep "Cold unhealth:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/coldUnhealth.$benchmark.txt
            grep "Hot write:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/hotWrite.$benchmark.txt
            grep "Cold write:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/coldWrite.$benchmark.txt
            grep "Hot clean:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/hotClean.$benchmark.txt
            grep "Cold clean:" $1/$policy/$benchmark.healthHotCold.txt | cut -f 3 -d ':' > $1/$policy/coldClean.$benchmark.txt
            case $policy in
                window) cut -f 3 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.policy.txt
                          cut -f 4 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.overProvisioning.txt
                          cut -f 5 -d '-' $1/$policy/$benchmark.types.txt | cut -f 1 -d '.' > $1/$policy/$policy.$benchmark.hotPoolSize.txt
                          cut -f 9 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.prob.txt
                          cut -f 2 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.benchmark.txt;;
                dynwindow) cut -f 3 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.policy.txt
                             cut -f 4 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.overProvisioning.txt
                             cut -f 5 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.hotPoolSize.txt
                             cut -f 6 -d '-' $1/$policy/$benchmark.types.txt | cut -f 1 -d '.' > $1/$policy/$policy.$benchmark.prob.txt
                             cut -f 2 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.benchmark.txt;;
                prob-promote) cut -f 4,5 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.policy.txt
                                cut -f 6 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.overProvisioning.txt
                                cut -f 7 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.hotPoolSize.txt
                                cut -f 8 -d '-' $1/$policy/$benchmark.types.txt | cut -f 1 -d '.' > $1/$policy/$policy.$benchmark.prob.txt
                                cut -f 3 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.benchmark.txt;;
                ori) cut -f 3 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.policy.txt
                       cut -f 4 -d '-' $1/$policy/$benchmark.types.txt | cut -f 1 -d '.' > $1/$policy/$policy.$benchmark.overProvisioning.txt
                       cut -f 9 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.hotPoolSize.txt
                       cut -f 9 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.prob.txt
                       cut -f 2 -d '-' $1/$policy/$benchmark.types.txt > $1/$policy/$policy.$benchmark.benchmark.txt;;
            esac
        done
    done


    for policy in ${POLICIES[@]}; do
        for benchmark in ${BENCHMARKS[@]}; do
            paste -d "," $1/$policy/$policy.$benchmark.benchmark.txt $1/$policy/$policy.$benchmark.policy.txt $1/$policy/$policy.$benchmark.overProvisioning.txt $1/$policy/$policy.$benchmark.hotPoolSize.txt $1/$policy/$policy.$benchmark.prob.txt  $1/$policy/$benchmark.responseTime.txt $1/$policy/*.$benchmark.txt > result.$policy.$benchmark.csv
        done
    done

    for benchmark in ${BENCHMARKS[@]}; do
      rm -f result.$benchmark.csv
      cat *.$benchmark.csv > result.$benchmark.csv
    done


