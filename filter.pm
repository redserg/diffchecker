
package Filter;
sub extra_executable{
	my ($db) = @_;

}
sub universal_regexp_filter_i{
	my ($db , $winpath_cond , $state_cond , $type_cond) = @_;
	print "universal_regexp_filter_i(,$winpath_cond,$state_cond,$type_cond)\n";
	while (my ($winpath , $ref) = each %$db){
		if( "$winpath" =~ m/($winpath_cond)/i ){
			if ( $ref->{'state'} =~ m/($state_cond)/i
				and $ref->{'type'} =~ m/($type_cond)/i){
				
				print "$winpath:$ref->{'state'}:$ref->{'type'}\n";	
			}

		}

	}
	return 0;

}
1;

