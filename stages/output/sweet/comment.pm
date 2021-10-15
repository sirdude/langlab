package comment;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(valid put);

sub valid {
	my (%node) = @_;
	if (($node->{"type"} eq "comment") ||
		($node->{"type"} eq "mulitcomment")) {
		return 1;
	}
	return 0;
}

sub put {
	my (%node) = @_;

	if (!valid(%node))) {
		return "";
	}
	return $node->{"value"};
}

1;
