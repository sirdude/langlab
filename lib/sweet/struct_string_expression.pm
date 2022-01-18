package struct_string_expression;

use strict;
use warnings;
use struct_string_term;

sub start {
	my ($ast) = @_;

	return struct_string_term::start($ast);
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_string_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node->{'type'} = 'expression';
	if (struct_string_term::get($ast, $tmp)) {
		push(@{$node->{'data'}}, $tmp);
	} else {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	while ($ast->match('+')) {
	    my $tnode = {};
		$tnode->{'type'} = $ast->consume();
		if (!struct_string_term::get($ast, $tmp)) {
			$ast->error('Expected term');
			$ast->pop_scope();
			return 0;
		}
		$tnode->{'data'} = $tmp;
		push(@{$node->{'data'}}, $tnode);
	}

	if (!$ast->match(';')) {
		$ast->error('end of string expression Expected ;');
		$ast->pop_scope();
		return 0;
	}

	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
