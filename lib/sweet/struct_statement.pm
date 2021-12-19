package struct_statement;
# This package covers both function and variable definitions.

use strict;
use warnings;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_statement::start');

	if start_typemod($ast) {
		return 1;
	}
	foreach my $i (@types) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
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
