#!/usr/bin/perl
use Data::Dumper;

print "$ARGV[0]\n";
my $diffsdir = $ARGV[0]; ################/
my %db;
&extract($diffsdir, \%db);
print Dumper(\%db);

print "$db{'startu.bat'}->{'path'}\n"; 			

sub extract{
	my ($diffsdir, $db) = @_;
	open my $rf, "<" , "$diffsdir/diff.files" or return -1;########## 
	while(<$rf>){
		if(m/'(.+?)'\s(\w+)\s(\w+_\d+)$/){
			my ($winpath, $state, $path) = ($1,$2,$3);
			if ($winpath ne ''){
					($db{$winpath}->{'state'}) = $state =~ /^(.)/ if($state ne '');
					$db{$winpath}->{'path'} = $path;
					
			}
		}
	}
	close $rf;



	for(keys %$db){
		&read_file_inf($diffsdir,$db,$_);
	}
}
		
sub read_file_inf{
	my ($diffsdir,$db,$winpath)= @_;
	my $size;
	my $type;
	my $file="$diffsdir/$db{$winpath}->{'path'}";
	if(-f $file){
		$size = -s $file;
		$type = `file -b '$file'`;
		chop $type;
		($type)=$type=~/^(.{0,512})/;
		$db{$winpath}->{'type'}= $type;
		$db{$winpath}->{'size'}= $size;
		
	}
	if(-d $file){
		my $len=length "$file/";
		my @all_files=glob "$file/*";
		for(@all_files){
			my $name=substr($_,$len);
			&read_file_inf($_,"$winpath/$name",$task_id, $state); 	
		}
	}
}
