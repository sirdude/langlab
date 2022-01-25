package struct_bracket;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_bracket::start');
	if ($ast->match('(')) {
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
	$ast->debug('struct_bracket::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('(');
	$node->{'type'} = 'expression';

	if (struct_expression::start($ast)) {
		if (!struct_expression::get($ast, $tmp)) {
			$ast->error("Expected expression.");
			$output = $node;
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;
	} else {
		$node->{'data'} = '';
	}

	if (!$ast->match(')')) {
		$ast->error("Expected ')'.");
		$ast->pop_scope();
		return 0;
	}

	$output = $node;
	$ast->pop_scope();
	return 1;
}

1;
