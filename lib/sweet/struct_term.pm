package struct_term;

use strict;
use warnings;

use struct_not_factor;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_term::start');

	return struct_not_factor::start($ast);
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_term::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node->{'type'} = 'term';
	if (struct_not_factor::get($ast, $tmp)) {
		push(@{$node->{'data'}}, $tmp);
	} else {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	while ($ast->match('*') || $ast->match('/')) {
	    my $tnode = ();
		$tnode->{'type'} = $ast->consume();
		if (!not_factor::get($ast, $tmp)) {
			$ast->error('Expected expression');
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
