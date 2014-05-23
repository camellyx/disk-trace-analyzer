#!/usr/bin/env perl

my $dir = "./retention/";

opendir(DIR, $dir) or die $!;

my @infiles 
= grep { 
/.csv$/            # Ends with a .pl
} readdir(DIR);

@infiles = sort @infiles;

closedir(DIR);

my @converted = ();
my @retention = (retention_in_day);
my @read_interv = (read_interval_in_day);

foreach my $filename (@infiles) {
  my @days = ($filename);
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
    if ($#converted == 0) {
      push(@retention,$fields[0]);
      push(@read_interv,$fields[1]);
    }
    push(@days,$fields[-1]);
  }
  close(FILE);
  push(@converted, \@days);
}
@converted = (\@retention,\@read_interv,@converted);
local $" = ', ';
#print "@@@ $#converted\n";

for (my $j=0; $j<=$#retention; $j++) {
  for (my $i=0; $i<=$#converted; $i++) {
    #print "@{$converted[$i]}\n";
    print "$converted[$i][$j], ";
  }
  print "\n";
}
