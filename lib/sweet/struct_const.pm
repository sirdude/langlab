package struct_const;
# This gets structure gets numbers of various types...

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	my @values = ('float', 'int', 'hex', 'html', 'string');

	$ast->debug('struct_const::start');
	foreach my $i (@values) {
		if ($ast->match_type($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_const::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume();

	$ast->pop_scope();

	return 1;
}

1;
