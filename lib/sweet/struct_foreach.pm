package struct_foreach;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_foreach::start');
	if ($ast->match('foreach')) {
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
	$ast->debug('struct_foreach::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('foreach');
	$node->{'type'} = 'foreach';

	if (!$ast->match_type('ident')) {
		error("struct_foreach::get expected var got: '" . $ast->peek() . "'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume();

	$node->{'iterator'} = $tmp;

	$tmp = $ast->consume('(');

	if (!struct_expression::get($ast, $tmp)) {
		$ast->pop_scope();
		return 0;
	}
	$node->{'items'} = $tmp;
	
	$tmp = $ast->consume(')');

	if (!struct_block::get($ast, $tmp)) {
		return 0;
	}
	$node->{'data'} = $tmp;

	$outast->add_node($node);
	
	$ast->pop_scope();
	return 1;
}

1;
