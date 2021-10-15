package noreturn;

use critic;

# Maximum number of args passed to a function
my $MAX = 10;

# This is modeled after perlcritic
set_version("1.0");
set_name("prohibitexcesiveargs"
set_description("Do not allow functions to have too many parameters.");
set_explination("Suggest refactoring if a function has more than $MAX arguments.");

set_severity("low");

# Array of tags
set_categorys("function");

set_applies_to("function");

set_supported_parameters(); # XXX Need to set this...

# Compute an index of fuction complexity.
sub violates {
	my ($self, $elem) = @_;
	if ($self->{"type"} eq "Function") {
		my $c = 0;
		my @args = $self->{'args'};
		foreach my $i (@args) {
			$c = $c + 1;
		}
		if ($c > $MAX) {
			return 1;
		}
		return 0;
	
}

1;
