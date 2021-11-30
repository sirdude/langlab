package tok_op;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	my @values = ('|', '-', '!', '#', '$', '%', '&', '(', ')', '*', '+',
		',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', ']',
		'^', '`', '{', '|', '}', '~', "\\");

	$ast->debug('op::start');
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($tmp, $op) = ('', '');
	my $doneop;

	# Make sure larger ops defined first
	my @multiop = ('>>=', '<<=',
		'!=', '==', '||', '>=', '<=', '++', '--', '&&', '>>', '<<', '+=',
		'-=', '*=', '/=', '%=', '&=', '|=', '^=', '?:', '->', '::', '<-',
		'!!', '=~', '=~', '..');

	$ast->push_scope();
	$ast->debug('op::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	foreach my $i (@multiop) {
		if ($ast->match($i)) {
			my $x = 0;
			while ($x < length($i)) {
				$tmp = $ast->consume();
				$op .= $tmp->{'data'};
				$x = $x + 1;
				$doneop = 1;
			}
		}
	}
	if (!$doneop) {
		$tmp = $ast->consume();
		$op = $tmp->{'data'};
	}
	$ast->debug("op::get: $op");
	$outast->add_node($outast, 'op', $op, $l, $p);
	$ast->add_stat('op', $op, 1);

	$ast->pop_scope();
	return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'op') {
		return $node->{'value'};
	}
	return '';
}

1;
