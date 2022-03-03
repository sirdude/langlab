package program;

use strict;
use warnings;
use Data::Dumper;

use packages;
use var_def;
use fun_def;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'sweet_program') {
		return 1;
	}

	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data = "<program>\n";

	foreach my $i ($self->{'packages'}) {
		if (packages::is($i)) {
			if (!packages::output($i, \$data)) {
				return 0;
			}
		} else {
				$self->error("Invalid package: " . Dumper($i));
				return 0;
		}
	}

	foreach my $i ($self->{'data'}) {
		if (vardef::is($i)) {
			if (!vardef::output($i, \$data)) {
				return 0;
			}
		} elsif (fundef::is($i)) {
			if (!fundef::output($i, \$data)) {
				return 0;
			}
		} else {
			$self->error("Not a variable or function definition: " . Dumper($i));
			return 0;
		}
	}

	$data .= "</program>\n";
	return 1;
}

1;
