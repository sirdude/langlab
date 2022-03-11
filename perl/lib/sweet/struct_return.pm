package struct_return;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_return::start');
	if ($ast->match('return')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('return');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('return');
	$node->{'type'} = 'return';

	if ($ast->match(';')) {
		$node->{'data'} = 'void';
		$ast->pop_scope();
		return 1;
	}

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$ast->pop_scope();
	return 1;
}

1;
