package struct_print;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_print::start');
	if ($ast->match('print')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('print');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume('print');
	$node->{'type'} = 'print';

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected string expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$ast->pop_scope();
	return 1;
}

1;
