package tok_num;

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

	$ast->debug('tok_num::start');
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
	my ($word, $tmp);

	$ast->push_scope();
	$ast->debug('tok_num::get:');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$word .= $tmp;
	while (start($ast)) {
		$tmp = $ast->consume();
		$word .= $tmp;
	}
	if ($ast->match('..')) {
		$ast->debug("tok_num::get $word");
		$ast->add_stat('num', 'int', 1);
		$outast->add_base_node('int', $word, $l, $p);
		$ast->pop_scope();
		return 1;
	} elsif ($ast->match('.')) {
		$tmp = $ast->consume();
		$word .= $tmp;
		while (start($ast)) {
			$tmp = $ast->consume();
			$word .= $tmp;
		}
		$ast->debug("tok_num::get $word");
		$ast->add_stat('num', 'float', 1);
		$outast->add_base_node('float', $word, $l, $p);
		$ast->pop_scope();
		return 1;
	}
	$ast->debug("tok_num::get $word");
	$ast->add_stat('num', 'int', 1);
	$outast->add_base_node('int', $word, $l, $p);
	$ast->pop_scope();
	return 1;
}

1;
