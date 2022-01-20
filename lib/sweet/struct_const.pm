package struct_const;
# This gets structure gets numbers of various types...

use strict;
use warnings;

use struct_expression;
use struct_exp_list;

sub start {
	my ($ast) = @_;
	my @values = ('float', 'int', 'hex', 'html');

	$ast->debug('struct_ident::start');
	foreach my $i (@values) {
		if ($ast->match_type($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_ident::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	# XXX Should redo this to copy more of the node...
	$node->{'data'} = $tmp;

	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
