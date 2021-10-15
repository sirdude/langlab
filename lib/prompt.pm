package prompt;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(prompt);

sub prompt {
	my @in = @_;
	my $value;

	print "$in[0]";
	chomp( $value = <STDIN> );

	return $value;
}

1;
