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

# XXX Not sure if we need this or not yet waiting...
sub is_type_str {
	my ($str) = @_;

	foreach my $i (@types) {
		if ($i eq $str) {
			return 1;
		}
	}
	return 0;
}

1;
