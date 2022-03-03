package packages;

use strict;
use warnings;
use Data::Dumper;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'package') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<package>\n";
	if ($self{'type'} eq 'use') {
		print "<use>\n";
		if (!expression::is($self{'data'})) {
			$self->error("Invalid package: " . Dumper($self{'data'});
			return 0;
		}
		if (!expression::output($self{'data'}, \$output) {
			return 0;
		}
		print "</use>\n";
	} elsif ($self{'type'} eq 'libpath') {
		print "<libpath>\n";
		if (!expression::is($self{'data'})) {
			$self->error("Invalid libpath: " . Dumper($self{'data'});
			return 0;
		}
		if (!expression::output($self{'data'}, \$output) {
			return 0;
		}
		print "</libpath>\n";
	}

	$data .= "</package>\n";
	return 1;
}

1;
