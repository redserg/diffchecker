#!/usr/bin/perl
require 'extractor.pm';
require 'filter.pm';
require 'main.conf';
use Data::Dumper;
use String::Approx 'amatch';
#print "$ARGV[0]\n";
my $diffsdir = $ARGV[0]; ################/
my %db;
Extractor::extract($diffsdir, \%db) and die "extractor error";
#print Dumper(\%db);
#for(keys (%db)){
#	print "$_\t\n";
#}
while (my ($winpath , $href) = each %db){
	print "$winpath\t$href->{'path'}\t$href->{'state'}\t$href->{'type'}\n";
}

#Filter::universal_regexp_filter_i(\%db, 'app', '' , 'dir' );
#Filter::universal_regexp_filter_i(\%db, '', '' , 'executable' );
#Filter::universal_regexp_filter_i(\%db, 'exe', '' , '' );

#my %sfp;
#Filter::extract_system_file_path(\%sfp, $SYSTEM_FILE_PATH);
#Filter::fuzzy_system_file_filter( \%db, \%sfp);
#print Dumper(\%sfp);
#Filter::universal_system_file_path_filter( \%db , \%sfp);

#my %extension_list, %type_list;
#Filter::extract_extension_list(\%extension_list, $EXTENSION_LIST);
#Filter::extension_list_filter(\%db,\%extension_list);
#print Dumper(\%extension_list);
#Filter::double_extension_filter(\%db); #not supported yet


#my %sp;
#Filter::extract_suspicious_path(\%sp, $SUSPICIOUS_PATH);
#print Dumper(\%sp);
#Filter::universal_suspicious_path_filter(\%db,\%sp, 'executable');

#Filter::path_list_filter( \%db, $SUSPICIOUS_PATH, 'e', 'executable');
