#/usr/bin/env bash

awk 'BEGIN{count=0;}{if ($5 == 0) count += ($4/8);}END{print "count=",count;}' $1

