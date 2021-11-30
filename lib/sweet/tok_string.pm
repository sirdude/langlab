package tok_string;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug('string::start');
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
	$ast->debug('string::get:');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$type = $tmp->{'data'};

	while (!$ast->match($ast->get_eof()) && !$ast->match($type)) {
		$tmp = $ast->consume();
		if ($tmp->{'data'} eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$word .= $tmp->{'data'};
			$tmp = $ast->consume();
			$word .= $tmp->{'data'};
		} else {
			$word = $word . $tmp->{'data'};
			$lastchr = $tmp->{'data'};
		}
	}
	$ast->debug("string::get: string = $word");

	$ast->add_stat('string', $type, 1);
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
