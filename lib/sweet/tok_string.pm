package tok_string;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug("string::starts");
	if ($ast->match('"') || $ast->match("'")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
	my $type;

	my $tmp = '';
	my $lastchr = '';
	my $word = '';

	$ast->push_scope();
	$ast->debug('string::get: ');

	if (!$ast->start()) {
		$ast->pop_scope();
		return 0;
	}

	$type = $ast->consume();

	while (!$ast->match($ast->get_eof()) && !$ast->match($type)) {
		$tmp = $ast->consume();
		if ($tmp eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$tmp = $tmp . $ast->consume();
		}
		$word = $word . $tmp;
		$lastchr = $tmp;
	}
	$ast->debug("string::get: string = $word");
	$ast->add_stat('string', $type, 1);
	# XXX Need to fix this...
	$outast->add_node($outast, 'string', $word, $l, $p);
	# eat the end of string token...
	$tmp = $ast->consume();

	$ast->pop_scope();

	return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'string') {
		return $node->{'value'};
	}
	return '';
}

1;
