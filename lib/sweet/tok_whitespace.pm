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

	$ast->push_scope();
	$ast->debug('whitespace::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	my $tmp = $ast->consume();
	my $word = $tmp->{'data'};

	if ($tmp eq ' ') {
		$ast->add_stat('whitespace', 'SPACE', 1);
	} else {
		$ast->add_stat('whitespace', $tmp, 1);
	}

	while($ast->match(' ') || $ast->match("\t") || $ast->match("\n") ||
		$ast->match("\r")) {

		$tmp = $ast->consume();
		$word = $word . $tmp->{'data'};

		if ($tmp eq ' ') {
			$ast->add_stat('whitespace', 'SPACE', 1);
		} else {
			$ast->add_stat('whitespace', $tmp, 1);
		}
	}
	$outast->add_node($outast, 'whitespace', $word, $l, $p);
	$ast->debug("whitespace::get added '$tmp\' length:" . length($tmp) . "\n");

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
