#!/usr/bin/env bash

WINFOLDER=../disksim-4.0-window
ORIFOLDER=../disksim-4.0-ori
WINPREFIX=../disksim-4.0-window/src
ORIPREFIX=../disksim-4.0-ori/src

pushd $ORIFOLDER
rm src/disksim
make
popd
pushd $WINFOLDER
rm src/disksim
make
popd
clear

for x in 10 15 20 25 30 35 40; do
#for x in 30 40; do
  # ori
  sed "s:xxxxx:$x:" ori-template.parv > ori-$x.parv

  echo "---Running tests with the real traces---"
  echo ""

  echo "IOzone: average SSD response time should be around 6.394276 ms"
  $ORIPREFIX/disksim ori-${x}.parv ssd-iozone-ori-${x}.outv ascii ssd-iozone-aligned2-100K.trace 0 
  grep "ssd Response time average:" ssd-iozone-ori-${x}.outv | grep -v "#"

  echo "Postmark: average SSD response time should be around 4.140330 ms"
  $ORIPREFIX/disksim ori-${x}.parv ssd-postmark-ori-${x}.outv ascii ssd-postmark-aligned2.trace 0 
  grep "ssd Response time average:" ssd-postmark-ori-${x}.outv | grep -v "#"

#  for y in 5 10; do
  for y in 5 10 15 20 25 30 35; do
    if [ "$x" -gt "$y" ]; then

      # window
      sed "s:xxxxx:$x:" window-template.parv | sed "s:yyyyy:$y:" > window-$x-${y}.parv

      echo "---Running tests with the real traces---"
      echo ""

      echo "IOzone: average SSD response time should be around 6.394276 ms"
      $WINPREFIX/disksim window-$x-${y}.parv ssd-iozone-window-$x-${y}.outv ascii ssd-iozone-aligned2-100K.trace 0 
      grep "ssd Response time average:" ssd-iozone-window-$x-${y}.outv | grep -v "#"

      echo "Postmark: average SSD response time should be around 4.140330 ms"
      $WINPREFIX/disksim window-$x-${y}.parv ssd-postmark-window-$x-${y}.outv ascii ssd-postmark-aligned2.trace 0 
      grep "ssd Response time average:" ssd-postmark-window-$x-${y}.outv | grep -v "#"

    fi
  done
done
