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

	$data .= "<binop>\n";
	$data .= "<optype>" . $self->{'type'} . "</optype>\n";

	if (!ident::is($self->{'lhs'})) {
		$self->error("Invalid package: " . Dumper($self->{'data'});
		return 0;
	}
	if (!ident::output($self->{'lhs'}, \$output) {
		return 0;
	}
	if (!expression::is($self->{'rhs'})) {
		$self->error("Invalid package: " . Dumper($self->{'data'});
		return 0;
	}
	if (!expression::output($self->{'rhs'}, \$output) {
		return 0;
	}

	$data .= "</binop>\n";
}

1;
