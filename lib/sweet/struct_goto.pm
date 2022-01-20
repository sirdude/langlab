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

	$ast->push_scope();
	$ast->debug('struct_while::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('goto');
	$node->{'type'} = 'goto';

	if ($ast->match(';')) {
		$ast->error("goto expected expression.");
		$ast->pop_scope();
		return 0;
	}

	if (!$ast->match_type('ident') && !$ast->match_type('label')) {
		$ast->error('Expected label');
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume();
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
