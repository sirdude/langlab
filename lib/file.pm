sub is_file {
	my ($infile) = @_;

	if (-f $infile) {
		return 1;
	}
	return 0;
}

sub is_dir {
	my ($infile) = @_;

	if (-f $infile) {
		return 1;
	}
	return 0;
}

sub get_extension {
	my ($infile) = @_;

}

sub get_path {
	my ($infile) = @_;

}

sub get_filename
