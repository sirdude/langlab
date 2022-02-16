package struct_return;

use strict;
use warnings;
use Data::Dumper;

use struct_expression;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_return::start');
	if ($ast->match('return')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_return::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('return');
	$node->{'type'} = 'return';

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

print Dumper(\%{$node});
	$ast->pop_scope();
	return 1;
}

1;
