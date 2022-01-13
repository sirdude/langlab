package struct_not_factor;

use strict;
use warnings;

use struct_factor;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_not_factor::start');

	if ($ast->match('!')) {
		return 1;
	}
	
	return struct_factor::start($ast);
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_not_factor::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	if ($ast->match('!')) {
	   $node->{'type'} = $ast->consume();
	}

	if (!struct_factor::get($ast, $tmp)) {
		return 0;
	}
	$output = $tmp;
	
	$ast->pop_scope();
	return 1;
}

1;
