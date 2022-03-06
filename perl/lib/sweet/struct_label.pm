package struct_label;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_label::start');
	if ($ast->match('label')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my ($tmp);
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_label::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('label');
	$node->{'type'} = 'label';

	if ($ast->match_type('ident')) {
		$node->{'data'} = $ast->consume();;

		$ast->pop_scope();
		return 1;
	}

	$ast->error("label Expected ';'");
	$ast->pop_scope();
	return 0;
}

1;
