package struct_if;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_if::start');
	if ($ast->match('if')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_if::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('if');
	$node->{'type'} = 'if';

	$tmp = $ast->consume('(');

	$node->{'test'} = struct_expression::get($ast);
	
	$tmp = $ast->consume(')');

	$node->{'data'} = struct_block::get($ast);

	# XXX look and get Optional else if

	if ($ast->peek('else') {
		$node->{'else'} = struct_block::get($ast);
	}

	$outast->add_node($node);
	
	$ast->pop_scope();
	return 1;
}

1;
