package struct_pkg;
# This package covers loading packages

use strict;
use warnings;

use struct_expression;
use struct_block;
use struct_params;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_def::start');
	if ($ast->match('use')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($tmp);
	my @tmods = ();
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_pkg::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	if (!$ast->match("lib")) {
		$node->{'type'} = 'use';
	} else {
		$node->{'type'} = 'libpath';
		$tmp = $ast->consume();
	}
	$node->{'data'} = struct_expression::get($ast);

	$outast->add_node($node);
	$ast->pop_scope();
	return 1;
}

1;
