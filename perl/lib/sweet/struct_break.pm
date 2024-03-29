package struct_break;

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
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('break');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume('break');
	$node->{'type'} = 'break';

	if ($ast->match(';')) {
		$node->{'data'} = 'void';
		$ast->pop_scope();
		return 1;
	}

	$ast->error("break Expected ';'");
	$ast->pop_scope();
	return 0;
}

1;
