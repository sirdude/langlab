package struct_assignment;

use strict;
use warnings;

use struct_expression;
use struct_block;
# use struct_ident; XXX Need to use this instead of lhs...

sub start {
	my ($ast) = @_;

	$ast->debug('struct_assignment::start');

	if (!$ast->match_type('ident')) {
		return 0;
	}

	if ($ast->peek(1) eq '=') { # XXX need to account for x[3] = 5;
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_assignment::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$node->{'type'} = 'assignment';
	$node->{'data'} = $tmp;

	if (!$ast->match('=')) {
		error('In assignment Expected =');
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume('=');

	if (!struct_expression::get($ast, $tmp)) {
		error('In assignment Expected expression');
		$ast->pop_scope();
		return 0;
	}

	$ast->{'rhs'} = $tmp;
	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
