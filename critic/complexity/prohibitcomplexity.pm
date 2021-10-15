package noreturn;

use critic;

# This is modeled after perlcritic
set_version("1.0");
set_name("prohibitcomplexity"
set_description("Do not allow functions to be overerly complex.");
set_explination("Compute an index on how complex a function is based on how many lines of code it is as well as how much nesting is going on.  If it is overly complex suggest refactoring it to make it simpler.");

set_severity("low");

# Array of tags
set_categorys("function");

set_applies_to("function");

set_supported_parameters(); # XXX Need to set this...

# Compute an index of fuction complexity.
sub violates {
	my ($self, $elem) = @_;

	# XXX do the work here...
}

1;
