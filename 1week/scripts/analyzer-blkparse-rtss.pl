#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

# Constants for blkparse
my $READ = "R";
my $WRITE= "W";
my $BLOCK_SIZE = 256*8; # block size = 256 * 8 KB = 2 MB
my $PAGE_SIZE = 8;

# Current state of the trace
my $cur_hour = 0;
my $offset_hour = 0;

# Tracking write intervals between within a flash block
my $cur_page = 0; # currently written bytes within a block
my $block_start = 0; # start hour

# Tracking retention time
my %last_write;
my %last_read;

# Statistics
my %write_intervals;
my %retentions;

my $max = int(0);
my $min = -1;

while (1) {
  if ($cur_hour >= 24*7) { # stop until 1 week
    last;
  }
  $offset_hour = $cur_hour;
  for (my $i=0; $i <= $#ARGV; $i++) {

    print STDERR "@@@@@@@@@ cur_hour: $cur_hour\n";
    if ($cur_hour >= 24*7) { # stop until 1 week
      last;
    }
    my $file = $ARGV[$i];
    print STDERR "@@ $file\n";
    open(FILE, $file) or die $!;
    while (<FILE>) {
      if ($cur_hour >= 24*7) { # stop until 1 week
        last;
      }
      chomp;
      my $line = $_;
      #print "$line\n";
      my @fields = split(/\ /);

      # Get fields
      my $type = $fields[-4];
      my $size = $fields[-5];
      my $block = $fields[-6];
      if ($block > $max) { $max = $block; }
      if ($min == -1) {
        $min = $block;
      } elsif ($block < $min) {
        $min = $block;
      }
      $cur_hour =   int($fields[0] / 3600000000000) + $offset_hour;
      #print "$type $size $block $fields[0] $cur_hour\n";
      if ($size % $PAGE_SIZE != 0) {
        $size = $size - ($size % $PAGE_SIZE) + $PAGE_SIZE;
      }
      if ($block % $PAGE_SIZE != 0) {
        $block = $block - ($block % $PAGE_SIZE) + $PAGE_SIZE;
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
      if (lc $type eq lc $WRITE) {
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
          $last_read{$block/$PAGE_SIZE} = $cur_hour;
          $size -= $PAGE_SIZE;
          $block += $PAGE_SIZE;
        }
      } elsif (lc $type eq lc $READ) {
        while ($size > 0) {
          my $write_time = 0;
          my $read_time = 0;
          if (exists($last_write{$block/$PAGE_SIZE})) {
            $write_time = $last_write{$block/$PAGE_SIZE};
            $read_time = $last_read{$block/$PAGE_SIZE};
          }
          my $retention = 10000 * ($cur_hour - $write_time) + ($cur_hour - $read_time);
          $last_read{$block/$PAGE_SIZE} = $cur_hour;
          #print "$retention\n";
          $retentions{$retention} ++;
          $size -= $PAGE_SIZE;
          $block += $PAGE_SIZE;
        }
      } else {
        print STDERR "Unknown access type: $type\n";
        exit 1;
      }
    } # end FILE
    close(FILE);
  }
}

# Print statistics
local $" = "\n";
print "write intervals: \n";
print Dumper(\%write_intervals);
print "retention times: \n";
print Dumper(\%retentions);
print "write time: \n";
print "min max\n";
print "$min $max\n{\n";
my @write_times = (0)x8;
for (my $i=0; $i<int($max/$PAGE_SIZE) + 1; $i++) {
  my $retention_day = 7;
  if (exists($last_write{$i})) {
    my $retention_day = int(($cur_hour - $last_write{$i})/24);
  }
  if ($retention_day < 7 and $retention_day >= 0) {
    $write_times[$retention_day] ++;
  } else {
    if ($retention_day < 0 or $retention_day > 7) {
      print STDERR "retention_day: $cur_hour - $last_write{$i} = $retention_day\n";
    }
    $write_times[7] ++;
  }
}
for (my $i=0; $i<8; $i++) {
  if ($i != 7) {
    print "$i,$write_times[$i]\n";
  } else {
    print "7+,$write_times[$i]\n";
  }
}
print "};\n";

exit 0;
