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
#!/usr/bin/perl
require '/etc/romashka.conf';
unshift (@INC ,$LIBROOT);
require 'db.pl';

system("date");
my $maindir="/data/romashka/postp";
my @paths=db_get_col("select postppath from tasks where diff>0 order by id");
my @result = sort @paths;#2012-02/00001362



for my $dir(@result){
	my %names;
	open my $rf, "<" , "$maindir/$dir/diffs/diff.files" or next;
	while(<$rf>){
		if(m/'(.+?)'\s(\w+)\s(\w+_\d+)$/){
			my ($winpath, $action, $path) = ($1,$2,$3);
			($names{$path} ->{'action'}) = $action =~ /^(.)/ if($action ne '');
			$names{$path} ->{'winpath'} = $winpath if($winpath ne '');
		}
	}
	close $rf;
	$dir =~ m#.*?/(\w*)$#;
	my $task_id = $1;
	for(keys %names){
		&read_file_inf("$maindir/$dir/diffs/$_",$names{$_}->{'winpath'},$task_id,$names{$_}->{'action'});
	}
}
		
sub read_file_inf{
	my ($file, $winpath, $task_id, $state)= @_;
	my $size;
	my $type;
	if(-f $file){
		$size = -s $file;
		$type = `file -b '$file'`;
		chop $type;
		($type)=$type=~/^(.{0,512})/;
		print "'$winpath','$task_id','$file',$size,'$type','$state'\n\n";
		#db_query("insert into diffs2 (winpath,task_id,path,size,filetype,state) values (?,?,?,?,?,?)",$winpath,$task_id,$file,$size,$type,$state);
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
system("date");
