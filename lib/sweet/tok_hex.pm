package tok_hex;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;

	$ast->debug('tok_hex::start');
        if ($ast->match('0x')) {
                return 1;
        }
        return 0;
}

sub valid {
	my ($ast) = @_;
        my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f');

        $ast->debug('hex::valid');
        foreach my $i (@values) {
                if ($ast->match($i)) {
                        return 1;
                }
        }
        return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($p, $l) = $ast->get_loc();
        my ($word, $tmp);

	$ast->push_scope();
        $ast->debug('hex::get');

        if (!start($ast)) {
		$ast->pop_scope();
                return 0;
        }

        $tmp = $ast->consume();
	$word = $tmp;
        $tmp = $ast->consume();
	$word .= $tmp;

        if (valid($ast)) {
		$tmp = $ast->consume();
                $word .= $tmp;
        } else {
		$ast->pop_scope();
                return 0;
        }

        $ast->debug("hex::get: $word");
        $ast->add_stat('literal', 'hex', 1);
        $outast->add_node('hex', $word, $l, $p);
	$ast->pop_scope();
        return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} ne 'hex') {
		return "";
	}
	return $node->{'value'};
}

1;
