package struct_case;

use strict;
use warnings;

use struct_case;
use struct_block;
use struct_ident;
use struct_const;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_case::start');
	if ($ast->match('case')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('case');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$ast->copy_node(\%{$node});
	$tmp = $ast->consume('case');
	$node->{'type'} = 'case';

	$tmp = {};
	if ($ast->match_type('ident')) {
		if (!struct_ident::get($ast, \%{$tmp})) {
			$ast->error('Case expected constant or variable');
			$ast->pop_scope();
			return 0;
		}
	} elsif (!struct_const::get($ast, \%{$tmp})) {
		$ast->error('Case expected constant or variable');
		$ast->pop_scope();
		return 0;
	}
	$node->{'value'} = $tmp;

	$tmp = {};
	if (!struct_block::get($ast, \%{$tmp})) {
		$ast->error('Expected :');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$ast->pop_scope();
	return 1;
}

1;
