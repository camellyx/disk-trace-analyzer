#!/usr/bin/env perl

@blocks = (0) x (1<<24);
$tot_blocks = 0;

sub popcount {
  my $num = shift(@_);
  my $cnt = 0;
  while ($num > 0) {
    if (($num & 1) != 0) {
      $cnt += 1;
    }
    $num = ($num>>1);
  }
  return $cnt;
}

sub getbit{
  my $addr = shift(@_);
  my $idx = ($addr>>8); # shift 3 + 5 bits
  my $bidx = (($addr>>3)&((1<<5)-1));
  return (($blocks[$idx]>>$bidx)&1);
}

sub setbit{
  my $addr = shift(@_);
  my $idx = ($addr>>8); # shift 3 + 5 bits
  my $bidx = (($addr>>3)&((1<<5)-1));
  $blocks[$idx] |= (1<<$bidx);
}

if ( @ARGV == 0 ) {
  print "Please enter a file name.\n";
  return;
}

my $file = $ARGV[0];
print $file;
open(FILE, $file) or die $!;

while (<FILE>) {
  chomp;
  my $line = $_;
  my @fields = split(/\ /);
  $\ = "\n";
  $, = ",";
  my $addr = $fields[2];
  my $size = $fields[3];
  while ($size > 0) {
    if ($addr < 0 || $size > 65536) {
      print "Error: $addr $size for $line\n";
    }
    if (getbit($addr) == 0) {
      setbit($addr);
      $tot_blocks += 1;
    }
    $addr += 8;
    $size -= 8;
  }
}

print $tot_blocks;
