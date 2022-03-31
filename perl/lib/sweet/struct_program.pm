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
	my ($ast, $node) = @_;
	my $tmp;

	$ast->push_scope('program');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$node->{'data'} = ();

	while (!$ast->at_eof() && ($ast->peek() ne '}')) {
	    if (struct_pkg::start($ast)) {
			if (!struct_pkg::get($ast, \%{$tmp})) {
				$ast->error('Expected pkg');
				$ast->pop_scope();
				return 0;
			}
			push(@{$node->{'packages'}}, $tmp);
		} elsif (struct_def::start($ast)) {
			if (!struct_def::get($ast, \%{$tmp})) {
				$ast->error('Expected function or var def');
				$ast->pop_scope();
				return 0;
			}
			push(@{$node->{'data'}}, $tmp);
		} else {
			$ast->error('Not a pkg or definition');
			$ast->pop_scope();
			return 0;
		}

	}
	$node->{'type'} = 'program';

	$ast->pop_scope();
	return 1;
}

1;
