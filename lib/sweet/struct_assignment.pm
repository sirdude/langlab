package struct_assignment;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_while::start');
	if ($ast->match_type('ident')) {
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
	$ast->debug('struct_assignment::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$node->{'type'} = 'assignment';
	$node->{'data'} = $tmp;

	if (!$ast->match('=')) {
# XXX Need to backtrack and or do other stuff here not assignment....
		$ast->pop_scope();
		return 0;

	}
	$tmp = $ast->consume('=');

	$node->{'rhs'} = struct_expression::get($ast);

	$outast->add_node($node);
	
	$ast->pop_scope();
	return 1;
}

1;
