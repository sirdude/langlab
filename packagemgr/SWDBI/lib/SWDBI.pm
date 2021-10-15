package SWDBI;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.01';

# Below is the template documenation for your module you need to edit this.

=head1 NAME

SWDBI - A module for XXX

=head1 SYNOPSIS

use SWDBI;
XXX;

=head1 DESCRIPTION

Stub documentation for SWDBI.  It looks like the author
of the textension was negligent enough to leave the stub
uneditied.

XXX

=head1 SEE ALSO

XXX Mention other useful documentation, related modules, man pages,
RFCs or standards.

If you have a mailing list set up for your module, put it here.

If you have a web site  set up for your module, put it here.

=head1 AUTHOR

Kent Mein <XXXYOUREMAILHERE>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Kent Mein

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut

sub load_lib {
	my ($prot, $options) = @_;

}

sub connect {
	my ($connectstr, $user, $passwd) = @_;

	my ($protocol, $options) = wplist($connectstr, ":");

	my $lib = load_lib($protocol, $options);

	my $dbh = $lib->connect($user, $passwd);

	return $dbh;
}
