#!/usr/bin/env perl

my $tot_writes = 0;

if ( @ARGV == 0 ) {
  print "Please enter a file name.\n";
  return;
}

my $file = $ARGV[0];
open(FILE, $file) or die $!;

while (<FILE>) {
  chomp;
  my $line = $_;
  my @fields = split(/\ /);
  $\ = "\n";
  $, = ",";
  my $size = $fields[3];
  my $rw = $fields[4];
  if ($rw == 0) {
    $tot_writes += $size/8;
  }
}

print $tot_writes;
