package struct_do_while;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_do_while::start');
	if ($ast->match('do')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('do_while');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume('do');
	$node->{'type'} = 'do_while';

	$tmp = {};
	if (!struct_block::get($ast, \%{$tmp})) {
		$ast->error('Expected block');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	if (!$ast->match('while')) {
		$ast->error('Expected keyword while');
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume('while');

	if (!$ast->match('(')) {
		$ast->error('Expected keyword while');
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume('(');

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'test'} = $tmp;

	$tmp = $ast->consume(')');

	$ast->pop_scope();
	return 1;
}

1;
