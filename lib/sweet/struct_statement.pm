package struct_statement;

use strict;
use warnings;

use struct_if;
use struct_while;
use struct_assignment;
use struct_foreach;
use struct_block;
use struct_def; # XXX should not allow nested functions...
use struct_print;
use struct_return;
use struct_exit;
use struct_goto;
use struct_break;
use struct_switch;
use struct_label;

# XXX Need to do functioncalls...

my @mods = ('struct_if',
	'struct_while',
	'struct_assignment',
	'struct_foreach',
	'struct_block',
	'struct_def',
	'struct_print',
	'struct_return',
	'struct_exit',
	'struct_break',
	'struct_goto',
	'struct_switch',
	'struct_label');

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
	'struct_block::get' => \&struct_block::get,
	'struct_def::start' => \&struct_def::start,
	'struct_def::get' => \&struct_def::get,
	'struct_print::start' => \&struct_print::start,
	'struct_print::get' => \&struct_print::get,
	'struct_return::start' => \&struct_return::start,
	'struct_return::get' => \&struct_return::get,
	'struct_exit::start' => \&struct_exit::start,
	'struct_exit::get' => \&struct_exit::get,
	'struct_break::start' => \&struct_break::start,
	'struct_break::get' => \&struct_break::get,
	'struct_goto::start' => \&struct_goto::start,
	'struct_goto::get' => \&struct_goto::get,
	'struct_switch::start' => \&struct_switch::start,
	'struct_switch::get' => \&struct_switch::get,
	'struct_label::start' => \&struct_label::start,
	'struct_label::get' => \&struct_label::get
);

sub no_semi {
	my ($fun) = @_;
	my @values = ('if', 'while', 'block', 'foreach');

	foreach my $i (@values) {
		if ($i eq $fun) {
			return 1;
		}
	}
	return 0;
}

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
	my $node = {};
	my $done = 0;
	my $tmp;

	$ast->push_scope();
	$ast->debug('struct_statement::get');

	# Assume we return 1 unless we run into an error.
	while (!$done) {
		$done = 1;
		foreach my $i (@mods) {
			if ($actions{$i . '::start'}->($ast)) {
				$ast->debug('Looking at ' . $i . '::get');
				if (!$actions{$i . '::get'}->($ast, $tmp)) {
					$ast->error("Expected $i");
					$ast->pop_scope();
					return 0;
				}
				if (!no_semi($i)) {
					if (!$ast->match(';')) {
						$ast->error("Expected ;");
						$ast->pop_scope();
						return 0;
					}
					$ast->consume(';');
				}
				$done = 0;
			}
		}
	}

	if (!$ast->match(')')) {
		$ast->error('Unable to find valid statement.');
		$ast->pop_scope();
		return 0;
	}

	$ast->pop_scope();
	return 1;
}

1;
