#!/usr/bin/perl
require 'extractor.pl';
use Data::Dumper;
#print "$ARGV[0]\n";
my $diffsdir = $ARGV[0]; ################/
my %db1;
Extractor::extract($diffsdir, \%db1);



print Dumper(\%db1);
