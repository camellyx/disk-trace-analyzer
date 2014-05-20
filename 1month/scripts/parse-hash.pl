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
      print "$fields[1],$fields[2]\n";
    }
  }
} else {
  # extract retention times
  my $start = 0;
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
      print "$fields[1], $fields[2]\n";
    }
  }
}


exit 0;
