package struct_block;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	my $i;

	$ast->debug('struct_def::start');
	if ($ast->match('{')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($word, $tmp);
	my $return = 0;

	$ast->push_scope();
	$ast->debug('struct_block::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume('{');

# XXX Do work here for grabbing statements....

	$tmp = $ast->consume('}');

# XXX build and add the node to our new tree

	$ast->pop_scope();
	return $return;
}

sub put {
	my ($node) = @_;

}

1;
