package struct_statement;
# This package covers both function and variable definitions.

use strict;
use warnings;

use struct_if;
use struct_while;
use struct_assignment;
use struct_foreach;
use struct_block;
# XXX Need to do these....
# use struct_return;
# use struct_exit;
# use struct_break;
# use struct_switch;
# use struct_default;
# use struct_continue;
# use struct_try;
# use struct_throw;

my @mods = ('struct_if',
	'struct_while',
	'struct_assignment',
	'struct_foreach',
	'struct_block');

my %actions = (
	'struct_if::start' => \&struct_if::start,
	'struct_if::get' => \&struct_if::get,
	'struct_while::start' => \&struct_while::start,
	'struct_while::get' => \&struct_while::get,
	'struct_assignment::start' => \&struct_assignment::start,
	'struct_assignment::get' => \&struct_assignment::get,
	'struct_foreach::start' => \&struct_foreach::start,
	'struct_foreach::get' => \&struct_foreach::get,
	'struct_block::start' => \&struct_block::start,
	'struct_block::get' => \&struct_block::get
);

sub start {
	my ($ast) = @_;

	$ast->debug('struct_statement::start');

	foreach my $i (@mods) {
		my $action = $i . '::start';

		if ($actions{$action}->($ast)) {
			return 1;
		}
	}

	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my ($p, $l) = $ast->get_loc();
	my $node = {};
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_statement::get');

	# Assume we return 1 unless we run into an error.
	while (!$done) {
		$done = 1;
		foreach my $i (@mods) {
		    
			if ($actions{$i . '::start'}->($ast)) {
				if (!$actions{$i . '::get'}->($ast, $output)) {
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
