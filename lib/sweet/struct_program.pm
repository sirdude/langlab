package struct_program;

use strict;
use warnings;

use struct_def;
use struct_pkg;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_program::start');

	if (struct_def::start($ast) || struct_pkg::start($ast)) {
		return 1;
	}
	if ($ast->at_eof()) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($done, $tmp);
	my $node = {};

	$ast->push_scope();
	$ast->debug('struct_program::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	while (!$ast->at_eof() && !$done) {
	    if (struct_pkg::start($ast)) {
			if (!struct_pkg::get($ast, $tmp)) {
				return 0;
			}
			$node->{'packages'} = $tmp;
		} elsif (struct_def::start($ast)) {
			if (!struct_def::get($ast, $tmp)) {
				return 0;
			}
			$node->{'data'} = $tmp;
		} else {
			$ast->error("Not a pkg or definition.");
			return 0;
		}
		$node->{'type'} = 'program';

		$outast->add_node($node);
	}
	$ast->pop_scope();
	return 1;
}

1;
