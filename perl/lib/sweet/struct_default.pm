package struct_default;

use strict;
use warnings;

use struct_case;
use struct_block;

sub start {
	my ($ast) = @_;

	$ast->debug('struct_default::start');
	if ($ast->match('default')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $node) = @_;
	my $tmp;
	my $return = 0;

	$ast->push_scope('default');
	$ast->debug($ast->get_hscope());

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$node = $ast->copy_node();
	$tmp = $ast->consume('default');
	$node->{'type'} = 'case';
	$node->{'case'} = 'default';

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
