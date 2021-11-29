package tok_num;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

	$ast->debug("num::starts");
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
	my $word;

	$ast->push_scope();
	$ast->debug("num::get:");

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$word = $ast->consume();
	while (start()) {
		$word = $word . $ast->consume();
	}
	if ($ast->match("..")) {
		$ast->debug("num::get $word");
		$ast->add_stat("num", "int", 1);
		$outast->add_node($outast, "int", $word, $l, $p);
		$ast->pop_scope();
		return 1;
	} elsif ($ast->match(".")) {
		$word = $word . $ast->consume();
		while (starts()) {
			$word = $word . $ast->consume();
		}
		$ast->debug("num::get $word");
		$ast->add_stat("num", "float", 1);
		$outast->add_node($outast, "float", $word, $l, $p);
		$ast->pop_scope();
		return 1;
	}
	$ast->debug("num::get $word");
	$ast->add_stat("num", "int", 1);
	$outast->add_node($outast, "int", $word, $l, $p);
	$ast->pop_scope();
	return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'int') {
		return $node->{"value"};
	}
	if ($node->{'type'} eq 'float') {
		return $node->{"value"};
	}
	return "";
}

1;
