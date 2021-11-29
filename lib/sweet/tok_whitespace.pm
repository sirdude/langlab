package tok_whitespace;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug("whitespace::starts");
	if ($ast->match("\n") || $ast->match("\t") || $ast->match(' ') ||
		$ast->match("\r")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));

	$ast->push_scope();
	$ast->debug("whitespace::get");

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	my $tmp = $ast->consume();
	my $word = $tmp;

	if ($tmp eq " ") {
		$ast->add_stat("whitespace", 'SPACE', 1);
	} else {
		$ast->add_stat("whitespace", $tmp, 1);
	}

	while($ast->match(" ") || $ast->match("\t") || $ast->match("\n") ||
		$ast->match("\r")) {

		$tmp = $ast->consume();
		$word = $word . $tmp;

		if ($tmp eq " ") {
			$ast->add_stat("whitespace", 'SPACE', 1);
		} else {
			$ast->add_stat("whitespace", $tmp, 1);
		}
	}
	add_token("whitespace", $word, $p, $l);
	$ast->debug("whitespace::get added '$tmp\' length:" . length($tmp) . "\n");

	$ast->pop_scope();
	return 1;
}

sub put {
	my ($node) = @_;

	if (!valid($node)) {
		return $node->{"value"};
	}
	return "";
}

1;
