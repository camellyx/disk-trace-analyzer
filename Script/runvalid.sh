#!/usr/bin/env bash

WINFOLDER=../disksim-4.0-window
ORIFOLDER=../disksim-4.0-ori
PROBFOLDER=../disksim-4.0-prob-promote
DWINFOLDER=../disksim-4.0-dynwindow
WINPREFIX=../disksim-4.0-window/src
ORIPREFIX=../disksim-4.0-ori/src
PROBPREFIX=../disksim-4.0-prob-promote/src
DWINPREFIX=../disksim-4.0-dynwindow/src

TEMPLATEFOLDER=templates
RESULTFOLDER=results

pushd $ORIFOLDER
rm src/disksim
make
popd
pushd $WINFOLDER
rm src/disksim
make
popd
pushd $PROBFOLDER
rm src/disksim
make
popd
pushd $DWINFOLDER
rm src/disksim
make
popd
clear

for x in 10 15 20 25 30 35 40; do
#for x in 30 40; do
  # ori
  mkdir -p $RESULTFOLDER/ori
  echo "ori-$x"
  sed "s:xxxxx:$x:" $TEMPLATEFOLDER/ori-template.parv > $TEMPLATEFOLDER/ori-$x.parv

  echo "---Running tests with the real traces---"
  echo ""

  echo "IOzone: average SSD response time should be around 6.394276 ms"
  $ORIPREFIX/disksim $TEMPLATEFOLDER/ori-${x}.parv $RESULTFOLDER/ori/ssd-iozone-ori-${x}.outv ascii ssd-iozone-aligned2-100K.trace 0 
  grep "ssd Response time average:" $RESULTFOLDER/ori/ssd-iozone-ori-${x}.outv | grep -v "#"

  echo "Postmark: average SSD response time should be around 4.140330 ms"
  $ORIPREFIX/disksim $TEMPLATEFOLDER/ori-${x}.parv $RESULTFOLDER/ori/ssd-postmark-ori-${x}.outv ascii ssd-postmark-aligned2.trace 0 
  grep "ssd Response time average:" $RESULTFOLDER/ori/ssd-postmark-ori-${x}.outv | grep -v "#"

#  for y in 5 10; do
  for y in 5 10 15 20 25 30 35; do
    if [ "$x" -gt "$y" ]; then

      # window
      mkdir -p $RESULTFOLDER/window
      echo "window-$x-$y"
      sed "s:xxxxx:$x:" $TEMPLATEFOLDER/window-template.parv | sed "s:yyyyy:$y:" > $TEMPLATEFOLDER/window-$x-${y}.parv

      echo "---Running tests with the real traces---"
      echo ""

      echo "IOzone: average SSD response time should be around 6.394276 ms"
      $WINPREFIX/disksim $TEMPLATEFOLDER/window-$x-${y}.parv $RESULTFOLDER/window/ssd-iozone-window-$x-${y}.outv ascii ssd-iozone-aligned2-100K.trace 0 
      grep "ssd Response time average:" $RESULTFOLDER/window/ssd-iozone-window-$x-${y}.outv | grep -v "#"

      echo "Postmark: average SSD response time should be around 4.140330 ms"
      $WINPREFIX/disksim $TEMPLATEFOLDER/window-$x-${y}.parv $RESULTFOLDER/window/ssd-postmark-window-$x-${y}.outv ascii ssd-postmark-aligned2.trace 0 
      grep "ssd Response time average:" $RESULTFOLDER/window/ssd-postmark-window-$x-${y}.outv | grep -v "#"

      for z in 0 1 2 4 8 16 32; do
        # prob-promote
        mkdir -p $RESULTFOLDER/prob-promote
        echo "prob-promote-$x-$y-$z"
        sed "s:xxxxx:$x:" $TEMPLATEFOLDER/prob-promote-template.parv | sed "s:yyyyy:$y:" | sed "s:zzzzz:$z:" > $TEMPLATEFOLDER/prob-promote-$x-$y-${z}.parv
  
        echo "---Running tests with the real traces---"
        echo ""
  
        echo "IOzone: average SSD response time should be around 6.394276 ms"
        $PROBPREFIX/disksim $TEMPLATEFOLDER/prob-promote-$x-$y-${z}.parv $RESULTFOLDER/prob-promote/ssd-iozone-prob-promote-$x-$y-${z}.outv ascii ssd-iozone-aligned2-100K.trace 0 
        grep "ssd Response time average:" $RESULTFOLDER/prob-promote/ssd-iozone-prob-promote-$x-$y-${z}.outv | grep -v "#"
  
        echo "Postmark: average SSD response time should be around 4.140330 ms"
        $PROBPREFIX/disksim $TEMPLATEFOLDER/prob-promote-$x-$y-${z}.parv $RESULTFOLDER/prob-promote/ssd-postmark-prob-promote-$x-$y-${z}.outv ascii ssd-postmark-aligned2.trace 0 
        grep "ssd Response time average:" $RESULTFOLDER/prob-promote/ssd-postmark-prob-promote-$x-$y-${z}.outv | grep -v "#"

      done

      for z in 1 4 16 32 64 128; do
        # dynwindow
        mkdir -p $RESULTFOLDER/dynwindow
        echo "dynwindow-$x-$y-$z"
        sed "s:xxxxx:$x:" $TEMPLATEFOLDER/dynwindow-template.parv | sed "s:yyyyy:$y:" | sed "s:zzzzz:$z:" > $TEMPLATEFOLDER/dynwindow-$x-$y-${z}.parv
  
        echo "---Running tests with the real traces---"
        echo ""
  
        echo "IOzone: average SSD response time should be around 6.394276 ms"
        $DWINPREFIX/disksim $TEMPLATEFOLDER/dynwindow-$x-$y-${z}.parv $RESULTFOLDER/dynwindow/ssd-iozone-dynwindow-$x-$y-${z}.outv ascii ssd-iozone-aligned2-100K.trace 0 
        grep "ssd Response time average:" $RESULTFOLDER/dynwindow/ssd-iozone-dynwindow-$x-$y-${z}.outv | grep -v "#"
  
        echo "Postmark: average SSD response time should be around 4.140330 ms"
        $DWINPREFIX/disksim $TEMPLATEFOLDER/dynwindow-$x-$y-${z}.parv $RESULTFOLDER/dynwindow/ssd-postmark-dynwindow-$x-$y-${z}.outv ascii ssd-postmark-aligned2.trace 0 
        grep "ssd Response time average:" $RESULTFOLDER/dynwindow/ssd-postmark-dynwindow-$x-$y-${z}.outv | grep -v "#"

      done
    fi
  done
done
