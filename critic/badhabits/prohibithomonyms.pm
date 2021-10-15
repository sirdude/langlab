package noreturn;

use critic;

# This is modeled after perlcritic
set_version("1.0");
set_name("prohibithomonyms"
set_description("Do not allow function names for standard library function names.");
set_explination("Overriding common library functions may cause unpredictable results, try to locate these beforehand.");

set_severity("low");

# Array of tags
set_categorys("function");

set_applies_to("function");

set_supported_parameters(); # XXX Need to set this...

sub registered_name {
	my ($name) = @_;
	my @names = ("rand", "read", "write", "exit"); # XXX Need to set these and or load them....

	foreach my $i (@names) {
		if ($name eq $i) {
			return 1;
		}
	}
	return 0;
}

# Look at function to name is a standard library call
sub violates {
	my ($self, $elem) = @_;

	if ($self->{"type"} eq "Function") {
		return registered_name($sef->{"name"});
	}
}

1;
