package tok_whitespace;

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	$ast->debug('whitespace::start');
	if ($ast->match("\n") || $ast->match("\t") || $ast->match(' ') ||
		$ast->match("\r")) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast, $keepws_flag) = @_;
	my ($p, $l) = $ast->get_loc();
	my $word = '';

	$ast->push_scope();
	$ast->debug('whitespace::get');

	while(start($ast)) {
		my $tmp = $ast->consume();
		$word = $word . $tmp;

		if ($tmp eq ' ') {
			$ast->add_stat('whitespace', 'SPACE', 1);
		} else {
			$ast->add_stat('whitespace', $tmp, 1);
		}
	}
	if ($word eq '') {
		$ast->pop_scope();
		return 0;
	}

	if ($keepws_flag) {
		$outast->add_base_node('whitespace', $word, $l, $p);
		$ast->debug("whitespace::get added '$word\' length:" . length($word) . "\n");
	}

	$ast->pop_scope();
	return 1;
}

1;
