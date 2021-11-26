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
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));
	my $word;

	$ast->push_scope();
	$ast->debug("num::get:");

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$word = consume();
	while (start()) {
		$word = $word . consume();
	}
	if ($ast->match("..")) {
		$ast->debug("num::get $word");
		$ast->add_stat("num", "int", 1);
		add_token("int", $word, $p, $l);
		$ast->pop_scope();
		return 1;
	} elsif ($ast->match(".")) {
		$word = $word . consume();
		while (starts()) {
			$word = $word . consume();
		}
		$ast->debug("num::get $word");
		$ast->add_stat("num", "float", 1);
		add_token("float", $word, $p, $l);
		$ast->pop_scope();
		return 1;
	}
	$ast->debug("num::get $word");
	$ast->add_stat("num", "int", 1);
	add_token("int", $word, $p, $l);
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
