#!/usr/bin/perl
require 'extractor.pm';
require 'filter.pm';
require 'main.conf';
use Data::Dumper;
use String::Approx 'amatch';
#print "$ARGV[0]\n";
#my $diffsdir = $ARGV[0]; ################/
#for(keys (%db)){
#	print "$_\t\n";
#}
#while (my ($winpath , $href) = each %db){
#	print "$winpath\t$href->{'path'}\t$href->{'state'}\t$href->{'type'}\n";
#}
my $mega_diff_dir = $ARGV[0];
my $x_all = 0;
my $a_path = 0;
my $b_ext = 0;
my $c_double = 0;
my $d_sys = 0;
my $e_fuzzy = 0;
@diffs = glob "$mega_diff_dir/*/diffs";
for ( @diffs ){
	print "$_\n";
	my @count = filter_it($_);
	$x_all += $count[0]; 
	$a_path += $count[1];		
	$b_ext +=  $count[2];
	$c_double +=  $count[3];
	$d_sys +=  $count[4];	
	$e_fuzzy +=  $count[5];
}
print "\n\n$x_all\n$a_path\n$b_ext\n$c_double\n$d_sys\n$e_fuzzy\n";

sub filter_it{
	my ($diffsdir) = @_;
	my %db;
	my $x = Extractor::extract($diffsdir, \%db);# and die "extractor error";
	#print Dumper(\%db);
	my %sp;
	Filter::extract_suspicious_path(\%sp, $SUSPICIOUS_PATH);
	#print Dumper(\%sp);
	my $a = Filter::universal_suspicious_path_filter(\%db,\%sp, 'executable');

	my %extension_list, %type_list;
	Filter::extract_extension_list(\%extension_list, $EXTENSION_LIST);
	my $b = Filter::extension_list_filter(\%db,\%extension_list);
	#print Dumper(\%extension_list);
	my $c = Filter::double_extension_filter(\%db); #not supported yet

	my %sfp;
	Filter::extract_system_file_path(\%sfp, $SYSTEM_FILE_PATH);
	#print Dumper(\%sfp);
	my $d = Filter::universal_system_file_path_filter( \%db , \%sfp);
	my $e = Filter::fuzzy_system_file_filter( \%db, \%sfp);
	print "$x\n$a\n$b\n$c\n$d\n$e\n";
	return ($x,$a,$b,$c,$d,$e);

}



