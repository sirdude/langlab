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
	my ($ast, $output) = @_;
	my $tmp;
	my $node = {};
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_default::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('default');
	$node->{'type'} = 'case';
	$node->{'case'} = 'default'; # XXX Need to make sure it can't get clobbered by var default or something.

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
