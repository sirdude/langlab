package tok_op;

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	my @values = ('|', '-', '!', '#', '$', '%', '&', '(', ')', '*', '+',
		',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', ']',
		'^', '`', '{', '|', '}', '~', "\\");

	$ast->debug('tok_op::start');
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
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
	$ast->debug('tok_op::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	foreach my $i (@multiop) {
		if ($ast->match($i)) {
			my $x = 0;
			while ($x < length($i)) {
				$tmp = $ast->consume();
				$op .= $tmp;
				$x = $x + 1;
				$doneop = 1;
			}
		}
	}
	if (!$doneop) {
		$tmp = $ast->consume();
		$op = $tmp;
	}
	$ast->debug("tok_op::get: $op");
	$outast->add_base_node('op', $op, $l, $p);
	$ast->add_stat('op', $op, 1);

	$ast->pop_scope();
	return 1;
}

1;
