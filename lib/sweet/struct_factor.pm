package struct_factor;

use strict;
use warnings;

use struct_num;
use struct_ident;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_factor::start');

	if ($ast->match('(')) {
		return 1;
	}
	if (struct_ident::start($ast)) {
		return 1;
	}
	return struct_num::start($ast);
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
			return 0;
		}
		$node->{'data'} = $tmp;
		$output = $node;
		$ast->pop_scope();
		return 1;
	} elsif (struct_ident::start($ast) {
		if (!struct_ident::get($ast,$tmp)) {
			return 0;
		}
	} elsif (!struct_num::get($ast,$tmp)) {
		return 0;
	}
	$output = $tmp;
	
	$ast->pop_scope();
	return 1;
}

1;
