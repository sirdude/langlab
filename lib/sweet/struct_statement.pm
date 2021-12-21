package struct_statement;
# This package covers both function and variable definitions.

use strict;
use warnings;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_statement::start');

# XXX do the work here...

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
