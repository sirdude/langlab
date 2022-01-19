package struct_exit;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_exit::start');
	if ($ast->match('exit')) {
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
	$ast->debug('struct_exit::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('exit');
	$node->{'type'} = 'exit';

	if ($ast->match(';')) {
		$node->{'data'} = 'void';
		$output = $node;
		$ast->pop_scope();
		return 1;
	}

	if (!struct_expression::get($ast, $tmp)) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
