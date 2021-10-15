package SWStateM;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.01';

# Documentation
=head1 NAME

SWStateM - A module to create a simple state machine

=head1 SYNOPSIS

use SWStateM;
XXX
=head1 DESCRIPTION

XXX

=head1 SEE ALSO

=head1 AUTHOR

Kent Mein <mein@umn.edu>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Kent Mein

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut

my numsates = 0;

our EXPORT = qw(
	add_state
	add_link
	);

# Add a new state
sub add_state {
	$numstates = $numstates + 1;
}

# Remove the specified state.
sub del_state {
	$numstates = $numstates - 1;
}

# Add a link between two states
sub add_link {
	my ($starts, $condition, $ends) = @_;
}

# Remove an existing link
sub del_link {
	my ($starts, $condition, $ends) = @_;
}

# Get the links of a given state
sub get_links {
	my ($state) = @_;
}

# Make a state a valid start state
sub add_start {
	my ($state) = @_;
}

sub del_start {
	my ($state) = @_;
}

# Make a state a valid end state
sub add_end {
	my ($state) = @_;
}

sub del_end {
	my ($state) = @_;
}

# Return all valid start states
sub query_start_states {
}

# Return all valid start states
sub query_end_states {
}

# Check to see if state is a valid end state
sub is_end {
	my ($state) = @_;
}

# Check to see if state is a valid start state
sub is_start {
	my ($state) = @_;
}

# Other things to add
#	parse input
#	check for unreachable states
#	check for unlinked states
#	check state for no outputs and not end state
#	check state for no inputs and not start state
#	Same condition going to multiple places
#	debugging (graph, dump of tree)
#	optimize states

1;
