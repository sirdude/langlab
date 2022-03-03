package fun_def;

use strict;
use warnings;
use Data::Dumper;

use fun_def_params;
use block;

sub is {
	my ($self) = @_;

	if ($self->{'type'} eq 'fun_def') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<fun_def>\n";
	$data .= "<type>" . $data->{'type'} . "</type>\n";
	$data .= "<typemods>\n";
	$data .= join($data->{'typemods'},",");
	$data .= "</typemods>\n";

	if (!fun_def_params::is($self->{'params'})) {
			$self->error("Invalid Paramaters: " . Dumper($self->{'params'});
			return 0;
	}

	if (!fun_def_params::output($self->{'data'}, \$output) {
		return 0;
	}

	if (!block::is($self->{'data'})) {
			$self->error("Invalid Function block: " . Dumper($self->{'data'});
			return 0;
	}

	if (!block::output($self->{'data'}, \$output) {
		return 0;
	}

	$data .= "</fun_def>\n";
	return 1;
}

1;
