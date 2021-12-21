package struct_block;

use strict;
use warnings;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_block::start');
	if ($ast->match('{')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_block::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('{');

	$node->{'data'} = ();
	while (!$ast->match('}') && !$done) {
		my %tmp = struct_statement::get($ast);
		if (%tmp) {
			push(@{$node->{'data'}}, $tmp);
		} else {
			$done = 1;
		}
	}

	$tmp = $ast->consume('}');
	if ($tmp) {
		$node->{'type'} = 'block';
		$node->{'columnnum'} = $p;
		$node->{'linenum'} = $l;

		$ast->pop_scope();

		$ast->add_node($node);

		return 1;
	}

	$ast->pop_scope();
	return 0;
}

1;
