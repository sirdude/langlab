package tok_hex;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;

        if ($ast->match('0x')) {
                return 1;
        }
        return 0;
}

sub valid {
	my ($ast) = @_;
        my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f');

        $ast->debug("hex::valid");
        foreach my $i (@values) {
                if ($ast->match($i)) {
                        return 1;
                }
        }
        return 0;
}

sub get {
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));
        my $word;

	$ast->push_scope();
        $ast->debug("hex::get");

        if (!start($ast)) {
		$ast->pop_scope();
                return 0;
        }

        $word = consume() . consume(); # grab the 0x
        if (valid()) {
                $word = $word . consume();
        } else {
		$ast->pop_scope();
                return 0;
        }

        if (valid()) {
                $word = $word . consume();
        } else {
		$ast->pop_scope();
                return 0;
        }

        $ast->debug("hex::get: $word");
        $ast->add_stat("literal", "hex", 1);
        add_token("hex", $word, $p, $l);
	$ast->pop_scope();
        return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} ne 'hex') {
		return "";
	}
	return $node->{"value"};
}

1;
