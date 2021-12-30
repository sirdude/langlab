package struct_statement;
# This package covers both function and variable definitions.

use strict;
use warnings;

use struct_if;
use struct_while;
use struct_assignment;
use struct_foreach;
# XXX Need to do these....
# use struct_return;
# use struct_exit;
# use struct_break;
# use struct_switch;
# use struct_continue;
# use struct_try;
# use struct_throw;

my @mods = ('struct_if',
	'struct_while',
	'struct_assignment',
	'struct_foreach',
	'struct_block');

sub start {
	my ($ast) = @_;

	$ast->debug('struct_statement::start');

	foreach my $i (@mods) {
		if ($i->start($ast)) {
			return 1;
		}
	}

	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $node = {};
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_statement::get');

	# Assume we return 1 unless we run into an error.
	while (!$done) {
		$done = 1;
		foreach my $i (@mods) {
			if ($i->start($ast)) {
				if (!$i->get($ast, $outast)) {
					return 0;
				}
				$done = 0;
			}
		}
	}

	$ast->pop_scope();
	return 1;
}

1;
