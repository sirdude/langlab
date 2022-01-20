package struct_switch;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_switch::start');
	if ($ast->match('switch')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_switch::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('switch');
	$node->{'type'} = 'switch';

	if (!struct_expression::get($ast, $tmp)) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'items'} = $tmp;
	
	if (!struct_block::get($ast, $tmp)) {
		$ast->error('Expected block');
		$ast->pop_scope();
		return 0;
	}

	$node->{'data'} = $tmp;
	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
