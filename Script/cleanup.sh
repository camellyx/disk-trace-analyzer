#!/usr/bin/env bash

rm -f templates/*[0-9]*.parv
make -C ../disksim-4.0-ori distclean
make -C ../disksim-4.0-window distclean
make -C ../disksim-4.0-prob-promote distclean
make -C ../disksim-4.0-dynwindow distclean

rm -f *.csv
