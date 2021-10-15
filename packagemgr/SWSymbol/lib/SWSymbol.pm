package SWSymbol;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.01';

# Below is the template documenation for your module you need to edit this.

=head1 NAME

SWSymbol - A module for ...

=head1 SYNOPSIS

use SWSymbol;
XXX

=head1 DESCRIPTION

XXX

=head1 SEE ALSO

XXX

=head1 AUTHOR

Kent Mein <mein@umn.edu>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Kent Mein

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut

our @EXPORT = wq(
	add_frame
	);

sub add_frame {
}

sub del_frame {
}

sub add_var {
	my ($state, $varname, $vartype, $data) = @_;
}

sub del_var {
	my ($state, $varname) = @_;
}

sub add_function {
	my ($state, $funname, $funtype, $inputs, $data) = @_;
}

sub del_fun {
	my ($state, $funname) = @_;
}

sub get_info { # Get the symbol table entry for entryname
	my ($state, $entryname) = @_;
}

sub query_type { # get the type of entryname
	my ($state, $entryname) = @_;
}

sub query_data { # get the data or subdata of entryname
	my ($state, $entryname, $subdata) = @_;
}

1;
