package struct_return;

use strict;
use warnings;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_break::start');
	if ($ast->match('break')) {
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
	$ast->debug('struct_break::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('break');
	$node->{'type'} = 'break';

	if ($ast->match(';')) {
		$node->{'data'} = 'void';
		$output = $node;
		$ast->pop_scope();
		return 1;
	}

	$ast->error("break Expected ';'");
	$ast->pop_scope();
	return 0;
}

1;
