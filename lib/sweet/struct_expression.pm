package struct_expression;

use strict;
use warnings;

use struct_const;
use struct_ident;
use struct_bracket;

my @binops = ('||', '&&', '==', '!=', '+=', '-=', '>=', '<=', '>', '<',
	'+', '=,', '*', '/');
my @unops = ('-', '+');

sub is_unop {
	my ($input) = @_;

	foreach my $i (@unops) {
		if ($input eq $i) {
			return 1;
		}
	}
	return 0;
}

sub is_binop {
	my ($input) = @_;

	foreach my $i (@binops) {
		if ($input eq $i) {
			return 1;
		}
	}
	return 0;
}

sub start {
	my ($ast) = @_;

	$ast->debug('struct_expression::start');
	if (struct_const::start($ast)) {
		return 1;
	}
	if (struct_ident::start($ast)) {
		return 1;
	}
	if (struct_bracket::start($ast)) {
		return 1;
	}
	if (is_unop($ast->peek())) {
		return 1;
	}

	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node->{'type'} = 'expression';

	if (is_unop($ast->peek())) {
		$tmp = $ast->consume();
		$node->{'type'} = $tmp;
		if (!get($ast, $tmp)) {
			$ast->error('Op ' . $node->{'type'} . ' expected expression');
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;

	} elsif (struct_const::start($ast)) {
		if (!struct_const::get($ast, $tmp)) {
			$ast->error('reading const');
			$ast->pop_scope();
			return 0;
		}
		if (is_binop($ast->peek())) {
			$node->{'type'} = $ast->consume();
			$node->{'lhs'} = $tmp;
			if (!get($ast, $tmp)) {
				$ast->error('reading rhs'); # XXX maybe remove this 
				$ast->pop_scope();
				return 0;
			}
			$node->{'rhs'} = $tmp;
		} else {
			# XXX node is a const only...
		}
	} elsif (struct_ident::start($ast)) {
		if (!struct_ident::get($ast, $tmp)) {
			$ast->error('reading const');
			$ast->pop_scope();
			return 0;
		}
		if ($ast->peek() eq '=') {
			$node->{'type'} = $ast->consume();
			$node->{'lhs'} = $tmp;
			if (!get($ast, $tmp)) {
				$ast->error('reading rhs'); # XXX maybe remove this 
				$ast->pop_scope();
				return 0;
			}
			$node->{'rhs'} = $tmp;
		} elsif (is_binop($ast->peek())) {
			$node->{'type'} = $ast->consume();
			$node->{'lhs'} = $tmp;
			if (!get($ast, $tmp)) {
				$ast->error('reading rhs'); # XXX maybe remove this 
				$ast->pop_scope();
				return 0;
			}
			$node->{'rhs'} = $tmp;
		} else {
			# XXX node is a ident only...
		}
	} elsif (struct_bracket::start($ast)) { 
		$node->{'type'} = 'expression';
		if (!struct_bracket::get($ast, $tmp)) {
			$ast->error('reading bracketed expression.');
			$ast->pop_scope();
			return 0;
		}
		$node->{'data'} = $tmp;
	} else {
		$ast->error('Expression expected unop, const or ident');
		$ast->pop_scope();
		return 0;
	}

	$output = $node;
	$ast->pop_scope();

	return 1;
}

1;
