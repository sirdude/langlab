package struct_string_term;

use strict;
use warnings;

use struct_ident;

sub start {
	my ($ast) = @_;

	if ($ast->match_type('string')) {
		return 1;
	}
	if ($ast->match_type('ident')) {
		return 1;
	}
	if ($ast->match_type('int') || $ast->match_type('float')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my @valid_types = ('int', 'float', 'string');
	my $done = 0;

	$ast->push_scope();
	$ast->debug('struct_string_expression::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	foreach my $i (@valid_types) {
		if (!$done && $ast->match_type($i)) {
			$tmp = $ast->consume();
			$done = 1;
		}
	} 
	if (!$done) {
		if (!struct_ident::get($ast, $tmp)) {
			error("Expected variable or function call.");
			$ast->pop_scope();
			return 0;
		}
	}

	$output = $tmp;
	$ast->pop_scope();

	return 1;
}

1;
