package binop;

use strict;
use warnings;
use Data::Dumper;

use expression;

my @OPS = ('||', '&&', '==', '!=', '+=', '-=', '>=', '<=', '>', '<',
	'+', '=,', '*', '/');

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

	# XXX do this

}

1;
