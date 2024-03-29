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
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('exit');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume('exit');
	$node->{'type'} = 'exit';

	if ($ast->match(';')) {
		$node->{'data'} = 'void';
		$ast->pop_scope();
		return 1;
	}

	$tmp = {};
	if (!struct_expression::get($ast, \%{$tmp})) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$ast->pop_scope();
	return 1;
}

1;
