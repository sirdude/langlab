package struct_expression;

use strict;
use warnings;

use struct_signed_term;
use struct_term;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_expression::start');

	return struct_signed_term::start($ast);
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node->{'type'} = 'expression';
	if (struct_signed_term::get($ast, $tmp)) {
		push(@{$node->{'data'}}, $tmp);
	} else {
		$ast->error("Expected signed_term got " . $ast->peek());
		$ast->pop_scope();
		return 0;
	}
	while ($ast->match('+') || $ast->match('-')) {
	    my $tnode = {};
		$tnode->{'type'} = $ast->consume();
		if (!term::get($ast, $tmp)) {
		$ast->error("Expected term got " . $ast->peek());
		$ast->pop_scope();
			return 0;
		}
		$tnode->{'data'} = $tmp;
		push(@{$node->{'data'}}, $tnode);
	}

	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
