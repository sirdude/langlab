package struct_foreach;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_foreach::start');
	if ($ast->match('foreach')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('foreach');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('foreach');
	$node->{'type'} = 'foreach';

	if (!$ast->match_type('ident')) {
		error('struct_foreach::get expected var');
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume();

	$node->{'iterator'} = $tmp;

	$tmp = $ast->consume('(');

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'items'} = $tmp;
	
	$tmp = $ast->consume(')');

	$tmp = {};
	if (!struct_block::get($ast, \%{$tmp})) {
		$ast->error('Expected block');
		$ast->pop_scope();
		return 0;
	}

	$node->{'data'} = $tmp;
	$ast->pop_scope();

	return 1;
}

1;
