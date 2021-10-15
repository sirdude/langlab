package noreturn;

use critic;

# This is modeled after perlcritic
set_version("1.0");
set_name("no return from function"
set_description("Non void function does not return a value.");
set_explination("Missing return value from function.");

set_severity("low");

# Array of tags
set_categorys("function");

set_applies_to("function");

set_supported_parameters(); # XXX Need to set this...

# Look at function to see if no return value
sub violates {
	my ($self, $elem) = @_;

# XXX Do this...
}

1;
