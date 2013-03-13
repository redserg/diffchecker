#!/usr/bin/perl


print "$ARGV[0]\n";
open my $rf, "<" , "$ARGV[0]" or die("open error");
%diffs;

sub read_file_inf{
	my ($file, $winpath, $task_id, $state)= @_;
	my $size;
	my $type;
	if(-f $file){
		$size = -s $file;
		$type = `file -b '$file'`;
		chop $type;
		#($type)=$type=~/^(.{0,512})/;
		print "'$winpath','$task_id','$file',$size,'$type','$state'\n\n";
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
