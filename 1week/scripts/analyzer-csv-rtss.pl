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
#my %last_write;
my $MAX_SIZE = 134217728;
my @last_write = (0)x$MAX_SIZE;

# Statistics
my %write_intervals;
my %retentions;

my $max = int(0);
my $min = -1;

while (1) {
  print STDERR "@@@@@@@@@@ cur_hour: $cur_hour\n";
  if ($cur_hour >= 24*7) { # stop until 1 week
    last;
  }
  $time_offset = $cur_hour;
  print STDERR "@@ $file\n";
  open(FILE, $file) or die $!;
  while (<FILE>) {
    if ($cur_hour >= 24*7) { # stop until 1 week
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
    if ($block/$PAGE_SIZE > $MAX_SIZE) {
      print STDERR "disk out of bound: $block\n";
      print STDERR "$line\n";
      exit -1;
    }
    if ($block > $max) { $max = $block; }
    if ($min == -1) {
      $min = $block;
    } elsif ($block < $min) {
      $min = $block;
    }
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
        #$last_write{$block/$PAGE_SIZE} = $cur_hour * 10000 + $cur_hour;
        $last_write[$block/$PAGE_SIZE] = $cur_hour * 10000 + $cur_hour;
        $size -= $PAGE_SIZE;
        $block += $PAGE_SIZE;
      }
    } elsif (lc $type eq lc $READ) {
      while ($size > 0) {
        my $write_time = 0;
        $write_time = $last_write[$block/$PAGE_SIZE];
        my $retention = $cur_hour * 10000 + $cur_hour - $write_time;
        if ($cur_hour > 0) {
          $last_write[$block/$PAGE_SIZE] = int($write_time/10000) * 10000 + $cur_hour;
        }
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
  my $retention_day = ($last_write[$i] >= 10000) ? int(($cur_hour - int($last_write[$i]/10000)) / 24) : 7;
  if ($retention_day < 7 and $retention_day >= 0) {
    $write_times[$retention_day] ++;
  } else {
    if ($retention_day < 0 or $retention_day > 7) {
      print STDERR "retention_day: $cur_hour - $last_write[$i] = $retention_day\n";
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
