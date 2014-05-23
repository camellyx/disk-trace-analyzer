#!/usr/bin/env perl

use strict;
use warnings;

open(FILE, $ARGV[0]) or die $!;

if ($ARGV[1] eq "wri") {
  # extract write intervals
  while (<FILE>) {
    chomp;
    my $line = $_;
    if ($line =~ /retention\ times/) {
      last;
    }
    my @fields = split(/['\ =>\ ,]+/, $line);
    if ($#fields >= 2) {
      my $hour = $fields[1];
      my $count = $fields[2];
      my $day = ($hour == 0) ? 0 : int(($hour-1)/24);
      print "$hour,$count\n";
      #print STDERR "$hour hours to $day days\n";
    }
  }
} else {
  # extract retention times
  my $start = 0;
  my @results = (0)x64;
  while (<FILE>) {
    chomp;
    my $line = $_;
    if ($start == 0) {
      if ($line =~ /retention\ times/) {
        $start = 1;
      }
      next;
    }
    my @fields = split(/['\ =>\ ,]+/, $line);
    if ($#fields >= 2) {
      my $hour = $fields[1];
      my $write_hour = int($hour/10000);
      my $read_hour = $hour % 10000;
      my $count = $fields[2];
      my $write_day = ($write_hour == 0) ? 0 : int(($write_hour-1)/24);
      my $read_day = ($read_hour == 0) ? 0 : int(($read_hour-1)/24);
      $results[$write_day * 8 + $read_day] += $count;
      #print "$write_day,$read_day,$count\n";
    }
  }
  for (my $i=0; $i<7; $i++) {
    for (my $j=0; $j<=$i; $j++) {
      print "$i,$j,$results[$i*8+$j]\n";
    }
  }
  for (my $j=0; $j<=7; $j++) {
    if ($results[7*8+$j] != 0) {
      print STDERR "look at $ARGV[0]\n";
    }
  }
}


exit 0;
