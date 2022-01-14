package struct_factor;

use strict;
use warnings;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_factor::start');

	if ($ast->match('(')) {
		return 1;
	}
	if ($ast->match_type('ident')) {
		return 1;
	}
	if ($ast->match_type('float') || $ast->match_type('int')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_factor::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	if ($ast->match('(')) {
		$node->{'type'} = $ast->consume();
		if (!struct_expression::get($ast,$tmp)) {
			$ast->error("Expected expression, got: " . $ast->peek());
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;
		$output = $node;
		$ast->pop_scope();
		return 1;
	} elsif ($ast->match_type('ident')) {
		$tmp = $ast->consume();
	} elsif ($ast->match_type('float') || $ast->match_type('int')) {
		$tmp = $ast->consume();
	} else {
		$ast->error("Expected ident, or number, got " . $ast->peek());
		$ast->pop_scope();
		return 0;
	}
	$output = $tmp;
	
	$ast->pop_scope();
	return 1;
}

1;
