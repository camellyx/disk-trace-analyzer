#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

# Constants for csv
my $READ = "Read";
my $WRITE= "Write";
my $BLOCK_SIZE = 256*8*1024; # block size = 256 * 8 KB = 2 MB
my $PAGE_SIZE = 8*1024;

my $file = $ARGV[0];

# Current state of the trace
my $cur_hour = 0;
my $first_hour = 0;
my $time_offset = 0;

# Tracking write intervals between within a flash block
my $cur_page = 0; # currently written bytes within a block
my $block_start = 0; # start hour

# Tracking retention time
my %last_write;

# Statistics
my %write_intervals;
my %retentions;

while (1) {
  print STDERR "@@@@@@@@@@ cur_hour: $cur_hour\n";
  if ($cur_hour >= 24*30) { # stop until 1 week
    last;
  }
  $time_offset = $cur_hour;
  print STDERR "@@ $file\n";
  open(FILE, $file) or die $!;
  while (<FILE>) {
    if ($cur_hour >= 24*30) { # stop until 1 week
      last;
    }
    chomp;
    my $line = $_;
    #print "$line\n";
    my @fields = split(/,/);

    # Get fields
    my $type = $fields[-4];
    my $size = $fields[-2];
    my $block = $fields[-3];
    if ($first_hour == 0) {
      $first_hour = int($fields[0] / 36000000000);
      $cur_hour = 0;
    } else {
      $cur_hour =   int($fields[0] / 36000000000) - $first_hour + $time_offset;
    }
    if ($size % $PAGE_SIZE != 0) {
      $size = $size - ($size % $PAGE_SIZE) + $PAGE_SIZE;
      # assertion
      #print STDERR "$line: has size $size\n";
      #<>
      #exit -1;
    }
    if ($block % $PAGE_SIZE != 0) {
      $block = $block - ($block % $PAGE_SIZE) + $PAGE_SIZE;
      # assertion
      #print STDERR "$block: has block $block\n";
      #<>
      #exit -1;
    }
    if ($size % $PAGE_SIZE != 0) {
      print STDERR "$line: has size $size\n";
      exit -1;
    }
    if ($block % $PAGE_SIZE != 0) {
      print STDERR "$line: has block $block\n";
      exit -1;
    }

    # Take actions
    if ($type eq $WRITE) {
      if ($cur_page == 0) {
        $block_start = $cur_hour;
      }
      $cur_page += $size;
      if ($cur_page >= $BLOCK_SIZE) {
        # Wrap around
        my $write_interval = $cur_hour - $block_start + 1;
        $write_intervals{$write_interval} ++;
        $cur_page %= $BLOCK_SIZE;
        if ($cur_page > 0) {
          $block_start = $cur_hour;
        }
      }
      while ($size > 0) {
        $last_write{$block/$PAGE_SIZE} = $cur_hour;
        $size -= $PAGE_SIZE;
        $block += $PAGE_SIZE;
      }
    } elsif ($type eq $READ) {
      while ($size > 0) {
        my $write_time = 0;
        if (exists($last_write{$block/$PAGE_SIZE})) {
          $write_time = $last_write{$block/$PAGE_SIZE};
        }
        my $retention = $cur_hour - $write_time;
        #print "$retention\n";
        $retentions{$retention} ++;
        $size -= $PAGE_SIZE;
        $block += $PAGE_SIZE;
      }
    }
  } # end FILE
  close(FILE);
}

# Print statistics
local $" = "\n";
print "write intervals: \n";
print Dumper(\%write_intervals);
  print "retention times: \n";
  print Dumper(\%retentions);

exit 0;
