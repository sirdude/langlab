package struct_if;

use strict;
use warnings;

use struct_expression;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_if::start');
	if ($ast->match('if')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_if::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('if');
	$node = {};
	$node->{'type'} = 'if';

	$tmp = $ast->consume('(');

	if (!struct_expression::get($ast, \$tmp)) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;
	
	$tmp = $ast->consume(')');

	if (!struct_block::get($ast, \$tmp)) {
		$ast->error('Expected block');
		$ast->pop_scope();
		return 0;
	}
	$node->{'ifcase'} = $tmp;

	if ($ast->match('else')) {
		$ast->consume('else');
		if (!struct_block::get($ast, \$tmp)) {
			$ast->error('Expected block');
			$ast->pop_scope();
			return 0;
		}
		$node->{'elsecase'} = $tmp;
	}

	$ast->pop_scope();

	return 1;
}

1;
