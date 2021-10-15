package whitespace;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(starts valid get);

sub starts {
        debug("whitespace::starts");
        if (match("\n") || match("\t") || match(' ') || match("\r")) {
                return 1;
        }
        return 0;
}

sub valid {
}

sub get {
        $SPACES = $SPACES + 1;
        debug("whitespace::get");
        my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});

        if (!starts()) {
                return 0;
        }

        my $tmp = get_char();
        my $word = $tmp;

        if ($tmp eq " ") {
                add_stat("whitespace", 'SPACE', 1);
        } else {
                add_stat("whitespace", $tmp, 1);
        }

        while(match(" ") || match("\t") || match("\n") || match("\r")) {
                $tmp = get_char();
                $word = $word . $tmp;

                if ($tmp eq " ") {
                        add_stat("whitespace", 'SPACE', 1);
                } else {
                        add_stat("whitespace", $tmp, 1);
                }
        }
        add_token("whitespace", $word, $p, $l);
        debug("whitespace::get added '$tmp\' length:" . length($tmp) . "\n");
        $SPACES = $SPACES - 1;
        return 1;
}

1;
