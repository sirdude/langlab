package tok_whitespace;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug('whitespace::start');
	if ($ast->match("\n") || $ast->match("\t") || $ast->match(' ') ||
		$ast->match("\r")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
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

	$outast->add_node('whitespace', $word, $l, $p);
	$ast->debug("whitespace::get added '$word\' length:" . length($word) . "\n");

	$ast->pop_scope();
	return 1;
}

sub put {
	my ($ast) = @_;

	if (!$ast->valid()) {
		return $ast->{'value'};
	}
	return '';
}

1;
