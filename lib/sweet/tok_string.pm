package tok_string;

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	$ast->debug('tok_string::start');
	if ($ast->match('"') || $ast->match("'")) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $type;

	my $tmp = '';
	my $lastchr = '';
	my $word = '';

	$ast->push_scope();
	$ast->debug('tok_string::get:');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$type = $tmp;

	while (!$ast->match('EOF') && !$ast->match($type)) {
		$tmp = $ast->consume();
		if ($tmp eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$word .= $tmp;
			$tmp = $ast->consume();
			$word .= $tmp;
		} else {
			$word = $word . $tmp;
			$lastchr = $tmp;
		}
	}
	$ast->debug("tok_string::get: string = $word");

	$ast->add_stat('string', $type, 1);
	$outast->add_base_node('string', $word, $l, $p);

	# eat the end of string token...
	$tmp = $ast->consume();

	$ast->pop_scope();

	return 1;
}

1;
