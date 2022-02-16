package struct_ident;
# This gets structure gets variables and function calls.

use strict;
use warnings;

use struct_expression;
use struct_exp_list;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_ident::start');
	if ($ast->match_type('ident')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_ident::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$node->{'data'} = $tmp;
	if ($ast->match('(')) {
		$node->{'type'} = 'function_call';
		$tmp = {};
		if (!struct_exp_list::get($ast, \%{$tmp})) {
			$ast->error('Invalid function param');
			$ast->pop_scope();
			return 0;
		}
		$node->{'params'} = $tmp;
	} else {
		$node->{'type'} = 'var';
		if ($ast->match('[')) {
			$tmp = $ast->consume();
			$tmp = {};
			if (!struct_expression::get($ast, \%{$tmp})) {
				$ast->error('Invalid variable index for var');
				$ast->pop_scope();
				return 0;
			}
			$node->{'index'} = $tmp;
			if (!$ast->match(']')) {
				$ast->error('Expecting close index for var:');
				$ast->pop_scope();
				return 0;
			}
		    $tmp = $ast->consume();
		}
	}

	$ast->pop_scope();

	return 1;
}

1;
