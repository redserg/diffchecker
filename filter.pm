
package Filter;
sub universal_regexp_filter_i{
	my ($db , $winpath_cond , $state_cond , $type_cond) = @_;
	print "\tuniversal_regexp_filter_i(,$winpath_cond,$state_cond,$type_cond)\n";
	while (my ($winpath , $href) = each %$db){
		if( "$winpath" =~ m/($winpath_cond)/i ){
			if ( $href->{'state'} =~ m/($state_cond)/i
				and $href->{'type'} =~ m/($type_cond)/i){
				
				print "$winpath:$href->{'state'}:$href->{'type'}\n";	
			}

		}

	}
	return 0;

}
sub extract_system_file_path{
	my ($sfp , $conf) = @_;
	open my $rf, "<" , "$conf" or return -1;
	while(<$rf>){
		if(m/^'(.+?)'\s'(.+?)'$/){
			my ($file , $path) = ($1 , $2);
			push  @{$sfp->{$file}}, $path;######mb tolower?//
		}
		else{
			warn "extract_system_file_path:$conf:bad string in system file conf:$_";
		}
	}
	close $rf;
	return 0;
}
	
sub universal_system_file_path_filter{
	my ( $db , $sfp ) = @_;
	print "\tuniversal_system_file_path\n";
	while ( my ($winpath, $href) = each %$db){
		while ( my ($file , $aref) = each %$sfp){
			if ($winpath =~ m/($file)$/i){
				my $flag = 1;
				for (@$aref){
					if($winpath =~ m/($_)/i){
						$flag = 0;
						break;
					}
				}
				if($flag){
					print "wrong path:\t$winpath:$href->{'state'}:$href->{'type'}\n";	
				}
				elsif($href->{'state'} =~ m/c/i){
					print "system file changed:\t$winpath:$href->{'state'}:$href->{'type'}\n";
					
				}
			
			}
		}
	
	}
	return 0;
}


sub get_extension{
	my ($winpath ) = @_;
	my $ext;
	if(scalar reverse($winpath) =~ m/([^\/\\]+)\./i){
		$ext = scalar reverse($1);
	}
	return $ext;
}
sub double_extension_filter{
	my ($db ) = @_;
	while ( my ($winpath, $href) = each %$db){
		my $ext = get_extension($winpath);
		if($ext){
			print "extension:$ext:$winpath\n";
		}
		else{
			print "no extension:$winpath\n";	
		}
	}
}
sub path_list_filter{
	my ($db , $path_conf , $state_cond , $type_cond) = @_;
	print "\tpath_list_filter(,$path_conf, $state_cond, $type_cond)\n";
	open my $rf, "<" , "$path_conf" or return -1;
	while(<$rf>){
		if(m/^'(.+)'$/){
			my $winpath_cond = $1;
			universal_regexp_filter_i($db, $winpath_cond, $state_cond, $type_cond);
		}
	}
}



1;

