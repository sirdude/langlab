package struct_signed_term;

use strict;
use warnings;

use struct_term;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_signed_term::start');

	if ($ast->match('+') || $ast->match('-')) {
		return 1;
	}
	return struct_term::start($ast);
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_signed_term::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	if ($ast->match('+') || $ast->match('-')) {
		$node->{'type'} = $ast->consume();
		if (!struct_term::get($ast, $tmp)) {
			$ast->error("Expected term, got: " . $ast->peek());
			$ast->pop_scope();
			return 0;
		}

		$node->{'data'} = $tmp;
		$output = $node;
	} else {
		if (!struct_term::get($ast, $tmp)) {
			$ast->error("Expected term, got: " . $ast->peek());
			$ast->pop_scope();
			return 0;
		}
		$output = $tmp;
	}
	
	$ast->pop_scope();
	return 1;
}

1;
