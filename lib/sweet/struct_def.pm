package struct_def;
# This package covers both function and variable definitions.

use strict;
use warnings;

use struct_types;
use struct_expression;
use struct_block;
use struct_fundef_params;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_def::start');

	if (struct_types::is_typemod($ast)) {
		return 1;
	}
	if (struct_types::is_type($ast)) {
		return 1;
	}

	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($tmp);
	my @tmods = ();
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_def::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	while(struct_types::is_typemod($ast)) {
		$tmp = $ast->consume();
		push(@tmods, $tmp);
	}

	$node->{'typemods'} = @tmods;

	if (!struct_types::is_type($ast)) {
		$ast->error("struct_def::get Expected 'type'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume();
	$node->{'return_type'} = $tmp;

	if (!$ast->match_type('ident')) {
		$ast->error("struct_def::get Expected 'ident'");
		$ast->pop_scope();
		return 0;
	} else { # Set the name of the function/var.....
		$tmp = $ast->consume();
		$node->{'data'} = $tmp;
	}

	if ($ast->match('(')) {
		$node->{'type'} = 'function_def';

		$tmp = ();

		if (!struct_fundef_params::get($ast, $tmp)) {
			$ast->error('Expected function definition params');
			$ast->pop_scope();
			return 0;
		}
		$node->{'fundef_params'} = $tmp;

		if (!struct_block::get($ast, $tmp)) {
			$ast->error('Expected block');
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;

		$ast->pop_scope();
		return 1;
	} else {
		$node->{'type'} = 'var_def';
		if ($ast->match('=')) {
			$ast->consume('=');
			if (!struct_expression::get($ast, $tmp)) {
				$ast->error('Expected expression');
				$ast->pop_scope();
				return 0;
			}
			$node->{'data'} = $tmp;
		}

		$output = $node;
		$ast->pop_scope();
		return 1;
	}
}

sub get_var_only {
	my ($ast, $output) = @_;
	my ($tmp);
	my @tmods = ();
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_def::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	while(struct_types::is_typemod($ast)) {
		$tmp = $ast->consume();
		push(@tmods, $tmp);
	}

	$node->{'typemods'} = @tmods;
	$tmp = $ast->consume();

	if (!struct_types::is_type($ast)) {
		$ast->error("struct_def::get Expected 'type'");
		$ast->pop_scope();
		return 0;
	}
	$tmp = $ast->consume();
	$node->{'return_type'} = $tmp;

	if (!$ast->match_type('ident')) {
		$ast->error("struct_def::get Expected 'ident'");
		$ast->pop_scope();
		return 0;
	} else { # Set the name of the function/var.....
		$tmp = $ast->consume();
		$node->{'data'} = $tmp;
	}
	$node->{'type'} = 'var_def';
	if ($ast->match('=')) {
		$ast->consume('=');
		if (!struct_expression::get($ast, $tmp)) {
			$ast->error('Expected expression');
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;
	}

	$output = $node;
	$ast->pop_scope();
	return 1;
}

1;
