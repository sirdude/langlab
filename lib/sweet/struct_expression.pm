package struct_expression;
# This package covers both function and variable definitions.

use strict;
use warnings;
my @starts = ('if');

sub start {
	my ($ast) = @_;

	$ast->debug('struct_expression::start');

	foreach my $i (@starts) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	# XXX Need to do the work here...

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
