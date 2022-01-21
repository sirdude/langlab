package struct_factor;

use strict;
use warnings;

use struct_const;
use struct_ident;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_factor::start');

	if ($ast->match('(')) {
		return 1;
	}
	if ($ast->match_type('ident')) {
		return 1;
	}
	return struct_const::start($ast);
}

sub get {
	my ($ast, $output) = @_;
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
			$ast->error('Expected expression');
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;
		$output = $node;
		$ast->pop_scope();
		return 1;
	} elsif ($ast->match_type('ident')) {
		if (!struct_ident::get($ast, $tmp)) {
			$ast->error('Expected var, array, hash or function call');
			$ast->pop_scope();
			return 0;
		}
	} elsif (!struct_const::get($ast, $tmp)) {
		$ast->error('Expected ident, or number');
		$ast->pop_scope();
		return 0;
	}
	$output = $tmp;
	
	$ast->pop_scope();
	return 1;
}

1;
