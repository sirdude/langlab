package block;

use strict;
use warnings;
use Data::Dumper;

use statement;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'block') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<block>\n";

	foreach my $i ($self->{'data'}) {
		if (!statement::is($self{'data'})) {
				$self->error("Invalid Function block: " . Dumper($self{'data'});
				return 0;
			}
		if (!statement::output($self{'data'}, \$output) {
			return 0;
		}
	}

	$data .= "</block>\n";
	return 1;
}

1;
