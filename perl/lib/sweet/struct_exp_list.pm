package struct_exp_list;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_exp_list::start');

	if ($ast->match('(')) {
		return 1;
	}

	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;
	my $done = 0;

	$ast->push_scope('exp_list');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume(); # Get rid of the (
	$node->{'type'} = 'exp_list';
	$node->{'data'} = ();

	if ($ast->match(')')) { # Empty list... 
		$tmp = $ast->consume(); # Get rid of the trailing )

		$ast->pop_scope();
		return 1;
	}

	while (!$done) {
		my $tnode = {};

		$tmp = {};
		if (!struct_expression::get($ast, \%{$tmp})) {
			$ast->error('Expected expression.');
			$ast->pop_scope();
			return 0;
		}
		$tnode->{'data'} = $tmp;
		$tnode->{'type'} = 'expression';
		push(@{$node->{'data'}}, $tnode);

		if (!$ast->match(',')) {
			$done = 1;
		} else {
			$tmp = $ast->consume(); # getting rid of ,
		}
	}

	if (!$ast->match(')')) {
	    $ast->error("struc_exp_list::get expecting closing ')'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume(); # Get rid of the trailing )

	$ast->pop_scope();

	return 1;
}

1;
