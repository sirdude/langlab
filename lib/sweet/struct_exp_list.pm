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
	my ($ast, $output) = @_;
	my $tmp;
	my $return = 0;
	my @params;
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_params::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume(); # Get rid of the (

	if ($ast->match(')')) { # Empty params list... 
		$tmp = $ast->consume(); # Get rid of the trailing )

		$output = @params;
		$ast->pop_scope();
		return 1;
	}

	while (!$done) {
		my $tnode = {};

		if (!struct_expression::get($ast, $tmp)) {
			error('Expected expression.');
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
	    error("struct_params::get expecting closing ')'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume(); # Get rid of the trailing )

	$output = @params;
	$ast->pop_scope();

	return 1;
}

1;
