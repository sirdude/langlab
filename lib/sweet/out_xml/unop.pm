package unop;

use strict;
use warnings;
use Data::Dumper;

my @OPS = ('-', '+');

sub is {
	my ($self) = @_;

	foreach my $i (@OPS) {
		if ($self->{'type'} eq $i) {
			return 1;
		}
	}

	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<unop>\n";
	$data .= "<optype>" . $self->{'type'} . "</optype>\n";

	if (!expression::is($self->{'data'})) {
		$self->error("Invalid package: " . Dumper($self->{'data'});
		return 0;
	}
	if (!expression::output($self->{'data'}, \$output) {
		return 0;
	}

	$data .= "</unop>\n";

}

1;
