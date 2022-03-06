package struct_pkg;
# This package covers loading packages

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_pkg::start');
	if ($ast->match('use')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my ($tmp);
	my @tmods = ();

	$ast->push_scope();
	$ast->debug('struct_pkg::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('use');

	if (!$ast->match("lib")) {
		$node->{'type'} = 'use';
	} else {
		$node->{'type'} = 'libpath';
		$tmp = $ast->consume();
	}

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected string expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	if (!$ast->match(';')) {
		$ast->error('pkg expected ; after package');
		$ast->pop_scope();
		return 0;
	}
	$ast->consume(';');

	$ast->pop_scope();

	return 1;
}

1;
