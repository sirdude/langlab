package struct_print;

use strict;
use warnings;

use struct_string_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_print::start');
	if ($ast->match('print')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_while::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('print');
	$node->{'type'} = 'print';

	if (!struct_string_expression::get($ast, $tmp)) {
		$ast->error('Expected string expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
