#/usr/bin/env bash

awk 'BEGIN{max=$3;}{if (max < $3) max=$3;}END{print "max=",max;}' $1
awk 'BEGIN{min=$3;}{if (min > $3) min=$3;}END{print "min=",min;}' $1
