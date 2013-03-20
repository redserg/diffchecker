#!/usr/bin/perl
require 'extractor.pm';
require 'filter.pm';
use Data::Dumper;
#print "$ARGV[0]\n";
my $diffsdir = $ARGV[0]; ################/
my %db;
Extractor::extract($diffsdir, \%db) and die "extractor error";

Filter::universal_regexp_filter_i(\%db, 'app', '' , 'dir' );
Filter::universal_regexp_filter_i(\%db, '', 'e' , 'executable' );
Filter::universal_regexp_filter_i(\%db, 'exe', '' , '' );

#print Dumper(\%db);