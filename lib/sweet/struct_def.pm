package struct_def;
# This package covers both function and variable definitions.

use strict;
use warnings;

my @types = ('void', 'int', 'float', 'string', 'object', 'mapping', 'mixed');
my @typemods = ('atomic', 'nomask', 'private', 'static');

sub start_typemod {
	my ($ast) = @_;

	foreach my $i (@typemods) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub start {
	my ($ast) = @_;
	my $i;

	$ast->debug('struct_def::start');

	if start_typemod($ast) {
		return 1;
	}
	foreach my $i (@types) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($tmp);
	my @tmods = ();
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_def::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	# XXX Need to get typemods and type here....
	# Need to set if it's a function or a variable declaration as well.
	while(start_typemod($ast)) {
		$tmp = $ast->consume();
		push(@tmods, $tmp);
	}
	$node->{'typemods'} = @tmods;
	$tmp = @ast->consume();

	if (!is_type($tmp)) {
		print "ERROR: struct_def::get Expected type got $tmp\n";
		$ast->pop_scope();
		return 0;
	}

	if (!match_type('ident')) {
		print "ERROR: struct_def::get Expected ident got $tmp\n";
		$ast->pop_scope();
		return 0;
	} else { # Set the name of the function/var.....
		$tmp = @ast->consume();
		$node->{'data'} = $tmp;
	}

# XXX Need to see if we are dealing with a function or a variable...

	$tmp = $ast->consume('(');

	$node->{'params'} = struct_params::get($ast);
	
	$tmp = $ast->consume(')');

	$node->{'data'} = struct_block::get($ast);

	$ast->pop_scope();
	return 1;
}

1;
