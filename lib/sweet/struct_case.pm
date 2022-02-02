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
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_case::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('case');
	$node->{'type'} = 'case';

	if ($ast->match_type('ident')) {
		if (!struct_ident::get($ast, \$tmp)) {
			$ast->error('Case expected constant or variable');
			$ast->pop_scope();
			return 0;
		}
	} elsif (!struct_const::get($ast, \$tmp)) {
		$ast->error('Case expected constant or variable');
		$ast->pop_scope();
		return 0;
	}
	$node->{'value'} = $tmp;

	if (!struct_block::get($ast, \$tmp)) {
		$ast->error('Expected :');
		$ast->pop_scope();
		return 0;
	}
	$node->{'data'} = $tmp;

	$output = $node;
	
	$ast->pop_scope();
	return 1;
}

1;
