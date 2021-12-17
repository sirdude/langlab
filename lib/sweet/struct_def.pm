package struct_def;
# This package covers both function and variable definitions.

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);
my @types = ('void', 'int', 'float', 'string', 'object', 'mapping', 'mixed');
my @typemods = ('atomic', 'nomask', 'private', 'static');

sub start_typemod {
	my ($ast) = @_;

	foreach $i (@typemods) {
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
	foreach $i (@types) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($word, $tmp);
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_def::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('if');
	$tmp = $ast->consume('(');

	# XXX Need to get expression here
	
	$tmp = $ast->consume(')');

	# XXX Need to get first block
	#
	# look and get Optional else if
	# get Optional else 
	#
	# put the node togeather
	
	if ($return) {
		# XXX add the node to our new tree
	}
	$ast->pop_scope();
	return $return;
}

sub put {
	my ($node) = @_;

}

1;
