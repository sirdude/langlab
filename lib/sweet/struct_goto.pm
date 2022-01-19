package struct_goto;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_goto::start');
	if ($ast->match('goto')) {
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

	$tmp = $ast->consume('return');
	$node->{'type'} = 'return';

	if ($ast->match(';')) {
		$ast->error("goto expected expression.");
		$ast->pop_scope();
		return 0;
	}

	if (!struct_expression::get($ast, $tmp)) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
