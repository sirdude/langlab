package struct_block;

use strict;
use warnings;

use struct_statement;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_block::start');
	if ($ast->match('{')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_block::get');

	if (!start($ast)) {
		$ast->error('struct_block::get called and not the start of a block');
		$ast->pop_scope();
		return 0;
	}

	$node = {};
	$node->{'type'} = 'block';
	$node->{'columnnum'} = $p;
	$node->{'linenum'} = $l;
	$node->{'data'} = ();

	$tmp = $ast->consume('{');

	while (!$ast->match('}') && !$done) {
	    $tmp = {};
		if (struct_statement::get($ast, \%{$tmp})) {
			push(@{$node->{'data'}}, $tmp);
		} else {
			$done = 1;
		}
	}

	if (!$ast->match('}')) {
		$ast->error('Expected end of block');
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('}');
	$ast->pop_scope();

	return 1;
}

1;
