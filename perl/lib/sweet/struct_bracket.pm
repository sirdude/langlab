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
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('bracket');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('(');
	$node->{'type'} = 'bracket';

	if (struct_expression::start($ast)) {
		$tmp = {};
		if (!struct_expression::get($ast, \%{$tmp})) {
			$ast->error("Expected expression.");
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

	$ast->pop_scope();
	return 1;
}

1;
