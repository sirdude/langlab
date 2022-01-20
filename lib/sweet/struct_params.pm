package struct_params;

use strict;
use warnings;

use struct_types;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_params::start');

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

		while (struct_types::is_typemod($ast)) {
			$tmp = $ast->consume();
			push(@{$tnode->{'typemods'}}, $tmp);
		}

		if (!struct_types::is_type($ast)) {
		    $ast->error('expected a valid type');
			$ast->pop_scope();
			return 0;
		}

		$tmp = $ast->consume();
		$tnode->{'param_type'} = $tmp;
		$tnode->{'type'} = 'param';

		$tmp = $ast->consume();
		$tnode->{'data'} = $tmp;

		push(@params, $tnode);

		if (!$ast->match(',')) {
			$done = 1;
		} else {
			$tmp = $ast->consume(); # getting rid of ,
		}
	}

	if (!$ast->match(')')) {
	    $ast->error("struct_params::get expecting closing ')'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume(); # Get rid of the trailing )

	$output = @params;
	$ast->pop_scope();

	return 1;
}

1;
