package struct_switch;

# use strict;
use warnings;

use struct_expression;
use struct_block;
use struct_case;
use struct_default;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_switch::start');
	if ($ast->match('switch')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_switch::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('switch');
	$node = {};
	$node->{'type'} = 'switch';

	if (!struct_expression::get($ast, \$tmp)) {
		$ast->error('Expected expression');
		$ast->pop_scope();
		return 0;
	}
	$node->{'variable'} = $tmp;
	
	if (!$ast->match('{')) {
		$ast->error("Switch expected '{'");
		$ast->pop_scope();
		return 0;
	}
	$ast->consume('{');

	while (struct_case::get($ast, \$tmp)) {
		my $hhh = $tmp->{'value'};
		$node->{'data'}{$hhh} = $tmp;
	}
	if (struct_default::start($ast)) {
		if (!struct_default::get($ast, \$tmp)) {
			$ast->error("error in get default");
			$ast->pop_scope();
			return 0;
		}
		$node->{'default'} = $tmp;
	}

	if (!$ast->match('}')) {
		$ast->error("Switch expected '}'");
		$ast->pop_scope();
		return 0;
	}
	$ast->consume('}');

	$ast->pop_scope();

	return 1;
}

1;
