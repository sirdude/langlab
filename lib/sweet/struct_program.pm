package struct_program;
# This package covers both function and variable definitions.

use strict;
use warnings;

use struct_def;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_def::start');

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
	my ($node, $done);

	$ast->push_scope();
	$ast->debug('struct_def::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	while (!$ast->at_eof() && !$done) {
		$node = struct_def();
		if (!$node) {
			$ast->pop_scope();
			return 0;
		} else {
			$outast->add_node($node);
		}
	}
	$ast->pop_scope();
	return 1;
}

1;
