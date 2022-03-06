package struct_types;

use strict;
use warnings;

my @types = ('void', 'int', 'float', 'string', 'object', 'hash', 'mixed');
my @typemods = ('atomic', 'nomask', 'private', 'static');

sub is_typemod {
	my ($ast) = @_;

	foreach my $i (@typemods) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub is_type {
	my ($ast) = @_;

	foreach my $i (@types) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

# XXX need to maybe move get typemods and get_type here to simplify other code?

1;
