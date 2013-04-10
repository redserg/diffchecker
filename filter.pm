
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
	my ( $db , $sfp) = @_;
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
sub extract_suspicious_path{
	my ($sp , $conf) = @_;
	open my $rf, "<" , "$conf" or return -1;
	while(<$rf>){
		if(m/^'(.+?)'$/){
			my ($path) = ($1);
			$sp->{$path}=1;######mb tolower?//
		}
		else{
			warn "extract_suspicious_path:$conf:bad string in system file conf:$_";
		}
	}
	close $rf;
	return 0;
}


sub universal_suspicious_path_filter{
	my ( $db , $sp, $type) = @_;
	print "\tsuspicious_path_filter\n";
	while ( my ($winpath, $href) = each %$db){
		if($href->{'type'} =~ m/executable/i){
			for my $path ( keys %$sp){
				if ($winpath =~ m/($path)/i){
					print "$winpath:$href->{'state'}:$href->{'type'}\n";
				}
			}
		}
	
	}
	return 0;

}
sub get_name_extension{
	my ($winpath ) = @_;
	my $ext;
	my $name;
	if(scalar reverse($winpath) =~ m/([^\/\\]+)\.(.*?)\//i){
		$ext = scalar reverse($1);
		$name = scalar reverse($2);
	}
	elsif(scalar reverse($winpath) =~ m/(.*?)\//i){
		$name = scalar reverse($1);
	}
	return ($name, $ext);
}
sub double_extension_filter{
	my ($db ) = @_;
	print "\tdouble_extension_filter\n";
	while ( my ($winpath, $href) = each %$db){
		if($href->{'type'} =~ m/($type)/i){
			my ($name,$ext) = get_name_extension($winpath);
			if($ext){
				my ($name1,$ext1) = get_name_extension($name);
				if($ext1){
					print "executable double extension:$ext1.$ext2:$winpath\n";
				}
			}
		}

		#my ($name,$ext) = get_name_extension($winpath);
		#if($ext){
		#	print "e:$ext:\t$name:\t$winpath\n";
		#}
		#else{
		#	print "no e:$winpath\n";	
		#}
	}
}
sub extract_extension_list{
	my ($el, $list_file) = @_;
	open my $rf, "<" , "$list_file" or return -1;
	while(<$rf>){
		if(m/^'(.+?)'\s'(.+?)'/){
			my ($ext, $type) = (lc $1, lc $2);
			$el->{$type}->{$ext}=1;
		}
		else{
			warn "extract_extension_list:$list_file:bad string:$_";
		}
	}
	close $rf;
	return 0;
}
sub extension_list_filter{
	my ($db, $el) = @_;
	print "\textension_list_filter\n";
	while ( my ($winpath, $href) = each %$db){
		my ($name,$ext) = get_name_extension($winpath);
		for(keys %$el){
			if($href->{'type'} =~ m/($_)/i){
				unless(defined($el->{$_}->{lc $ext})){
					print "$winpath:$href->{'state'}:$href->{'type'}\n";	
				}
			}
		}
	}

}
#sub path_list_filter{
#	my ($db , $path_conf , $state_cond , $type_cond) = @_;
#	print "\tpath_list_filter(,$path_conf, $state_cond, $type_cond)\n";
#	open my $rf, "<" , "$path_conf" or return -1;
#	while(<$rf>){
#		if(m/^'(.+)'$/){
#			my $winpath_cond = $1;
#			universal_regexp_filter_i($db, $winpath_cond, $state_cond, $type_cond);
#		}
#	}
#}



1;

