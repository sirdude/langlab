package struct_statement;
# This package covers both function and variable definitions.

use strict;
use warnings;

use struct_if;
use struct_while;
use struct_assignment;
use struct_foreach;

# XXX Not quite right, how about null case?
sub start {
	my ($ast) = @_;
	my @mods = ('struct_if', 'struct_while', 'struct_assignment', 'struct_foreach');

	$ast->debug('struct_statement::start');

	foreach my $i (@mods) {
		if ($i->start($ast)) {
			return 1;
		}
	}

	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_statement::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->pop_scope();
	return $return;
}

1;
