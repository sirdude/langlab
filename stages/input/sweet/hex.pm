package hex;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(starts valid get);

sub starts {
        if (match('0x')) {
                return 1;
        }
        return 0;
}

sub valid {
        my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f');

        debug("hex::valid");
        foreach my $i (@values) {
                if (match($i)) {
                        return 1;
                }
        }
        return 0;
}

sub get {
        my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
        my $word;

        $SPACES = $SPACES - 1;
        debug("hex::get");

        if (!starts()) {
                return 0;
        }

        $word = get_char() . get_char(); # grab the 0x
        if (valid()) {
                $word = $word . get_char();
        } else {
                return 0;
        }

        if (valid()) {
                $word = $word . get_char();
        } else {
                return 0;
        }

        debug("hex::get: $word");
        add_stat("literal", "hex", 1);
        add_token("hex", $word, $p, $l);
        $SPACES = $SPACES - 1;
        return 1;
}

1;
