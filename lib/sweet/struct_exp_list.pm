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
	my @params;
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_exp_list::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume(); # Get rid of the (

	if ($ast->match(')')) { # Empty list... 
		$tmp = $ast->consume(); # Get rid of the trailing )

		$node = ();
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
		push(@params, $tnode);

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

	$node = @params;
	$ast->pop_scope();

	return 1;
}

1;
