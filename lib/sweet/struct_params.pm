package struct_params;
# This package covers both function and variable definitions.

use strict;
use warnings;

my @types = ('void', 'int', 'float', 'string', 'object', 'mapping', 'mixed');
my @typemods = ('atomic', 'nomask', 'private', 'static');

sub start_typemod {
	my ($ast) = @_;

	foreach my $i (@typemods) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub start {
	my ($ast) = @_;

	$ast->debug('struct_params::start');

	if ($ast->match('(')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $return = 0;
	my @params;

	$ast->push_scope();
	$ast->debug('struct_params::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume(); # Get rid of the (

	while ($ast->match_type('type') || $ast->match_type('typemod')) {
# XXX Need to work on typemod stuff here... 
		$tmp = $ast->consume();
		my $tnode = {};
		$tnode->{'param_type'} = $tmp;
		$tmp = $ast->consume();
		$tnode->{'data'} = $tmp;
		push(@params, $tnode);
		if ($ast->match(',')) {
			$tmp = $ast->consume();
		}
	}

	if (!$ast->match(')')) {
	    error("struct_arams::get expecting closing ')' got: '" . $ast->peek() . "'");
		return 0;
	}
	$tmp = $ast->consume(); # Get rid of the trailing )
# XXX Need to finish setting $node and return it?

	$ast->pop_scope();
	return @params;
}

1;
