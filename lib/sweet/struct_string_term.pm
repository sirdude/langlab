package struct_string_term;

use strict;
use warnings;

sub start {
	my ($ast) = @_;

	if ($ast->match_type('string')) {
		return 1;
	}
	if ($ast->match_type('ident')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_string_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	if ($ast->match_type('string')) {
		$tmp = $ast->consume();
	} else {
		# XXX Need to get function call or variable call.
	}

	$output = $tmp;
	$ast->pop_scope();

	return 1;
}

1;
