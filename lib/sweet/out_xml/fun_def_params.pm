package fun_def_params;

use strict;
use warnings;
use Data::Dumper;

use fun_def_params;
use block;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'fundef_params') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<fun_def_params>\n";
	foreach my $i ($self{'data'}) {
		if (!output_param($i, $data)) {
			$self->error("Invalid param: " . Dumper($i));
			return 0;
		}
	}

	$data .= "</fun_def_params>\n";
	return 1;
}

sub output_param {
	my ($self, $data) = @_;

	$data .= "<def_param>";
	# XXX Fill this in...
	$data .= "</def_param>";

	return 1;
}

1;
