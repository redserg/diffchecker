#!/usr/bin/perl
require 'extractor.pm';
require 'filter.pm';
require 'main.conf';
use Data::Dumper;
#print "$ARGV[0]\n";
my $diffsdir = $ARGV[0]; ################/
my %db;
Extractor::extract($diffsdir, \%db) and die "extractor error";

#Filter::universal_regexp_filter_i(\%db, 'app', '' , 'dir' );
#Filter::universal_regexp_filter_i(\%db, '', 'e' , 'executable' );
#Filter::universal_regexp_filter_i(\%db, 'exe', '' , '' );

#my %sfp;
#Filter::extract_system_file_path(\%sfp, $SYSTEM_FILE_PATH);
#print Dumper(\%sfp);
#Filter::universal_system_file_path_filter( \%db , \%sfp);
my %el;
Filter::extract_extension_list(\%el, $EXTENSION_LIST);
print Dumper(\%el);
#Filter::double_extension_filter(\%db); #not supported yet

#Filter::path_list_filter( \%db, $SUSPICIOUS_PATH, 'e', 'executable');
