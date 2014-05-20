#!/usr/bin/env perl

my $dir = "./retention/";

opendir(DIR, $dir) or die $!;

my @infiles 
= grep { 
/.csv$/            # Ends with a .pl
} readdir(DIR);

closedir(DIR);

my @converted = ([days,1..30]);

foreach my $filename (@infiles) {
  my @days = ($filename,(0)x30);
  $filename = $dir.$filename;
  #print "@@@ $filename\n";
  open(FILE, $filename) or die $!;
  while (<FILE>) {
    chomp;
    my $line = $_;
    if ($line =~ /retention/) {
      next;
    }
    my @fields = split(/,/);
    $day = ($fields[0] == 0) ? 0 : int(($fields[0]-1)/24);
    $days[$day+1] += int($fields[1]);
  }
  close(FILE);
  push(@converted, \@days);
}
local $" = ', ';
#print "@@@ $#converted\n";

for (my $j=0; $j<=30; $j++) {
  for (my $i=0; $i<=$#converted; $i++) {
    #print "@{$converted[$i]}\n";
    print "$converted[$i][$j], ";
  }
  print "\n";
}
