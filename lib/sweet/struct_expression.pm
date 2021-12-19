package struct_expression;
# This package covers both function and variable definitions.

use strict;
use warnings;
my @starts = ('if');

sub start {
	my ($ast) = @_;

	$ast->debug('struct_expression::start');

	foreach my $i (@starts) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('if');
	$tmp = $ast->consume('(');

	# XXX Need to get expression here
	
	$tmp = $ast->consume(')');

	# XXX Need to get first block
	#
	# look and get Optional else if
	# get Optional else 
	#
	# put the node togeather
	
	if ($return) {
		# XXX add the node to our new tree
	}
	$ast->pop_scope();
	return $return;
}

1;
