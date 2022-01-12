package struct_while;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_while::start');
	if ($ast->match('while')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_while::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('while');
	$node->{'type'} = 'while';

	$tmp = $ast->consume('(');

	if (!struct_expression::get($ast, $tmp)) {
		$ast->pop_scope();
		return 0;
	}
	$node->{'test'} = $tmp;

	$tmp = $ast->consume(')');

	if (!struct_block::get($ast, $tmp)) {
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
