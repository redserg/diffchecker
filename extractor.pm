package Extractor;
sub extract{
	my ($diffsdir, $db) = @_;
	open my $rf, "<" , "$diffsdir/diff.files" or return -1;########## 
	while(<$rf>){
		if(m/^'(.+?)'\s(\w+)\s(\w+_\d+)$/){
			my ($winpath, $state, $path) = ($1,$2,$3);
			if ($winpath ne ''){
					($db->{$winpath}->{'state'}) = $state =~ /^(.)/ if($state ne '');
					$db->{$winpath}->{'path'} = $path;
					
			}
		}
	}
	close $rf;

	my $count = 0;
	for(keys %$db){
		$count += &read_file_inf($diffsdir,$db,$_);
	}
	return $count;
}
		
sub read_file_inf{
	my ($diffsdir,$db,$winpath)= @_;
	my $size;
	my $type;
	my $file="$diffsdir/$db->{$winpath}->{'path'}";
	my $count = 1;
	if(-f $file){
		$size = -s $file;
		$type = `file -b '$file'`;
		chop $type;
		($type)=$type=~/^(.{0,512})/;
		$db->{$winpath}->{'type'}= $type;
		$db->{$winpath}->{'size'}= $size;
		
	}
	elsif(-d $file){ #directories have no size
		$db->{$winpath}->{'type'}= 'directory';
		my $len=length "$file/";
		my @all_files=glob "$file/*";###########hve to use state?
		for(@all_files){
			my $name=substr($_,$len);
			my $new_winpath = "$winpath/$name";
			$db->{$new_winpath}->{'path'} = "$db->{$winpath}->{'path'}/$name";
			$db->{$new_winpath}->{'state'} = $db->{$winpath}->{'state'};
			$count += &read_file_inf($diffsdir, $db , $new_winpath); 	

		}
	}
	else{
		$db->{$winpath}->{'state'}= "d";
		delete $db->{$winpath};
		warn "extractor:$file does not exist\n";
	}
	return $count;
}
1;
