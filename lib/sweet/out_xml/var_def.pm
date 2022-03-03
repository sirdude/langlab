package var_def;

use strict;
use warnings;
use Data::Dumper;

use expression;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'var_def') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<var_def>\n";
	$data .= "<type>" . $data->{'type'} . "</type>\n";
	$data .= "<typemods>\n";
	$data .= join($data->{'typemods'},",");
	$data .= "</typemods>\n";
	if ($self->{'data'}) {
		print "<assignment>\n";
		if (!expression::is($self{'data'})) {
			$self->error("Invalid package: " . Dumper($self{'data'});
			return 0;
		}
		if (!expression::output($self{'data'}, \$output) {
			return 0;
		}
		print "</assignment>\n";
	}

	$data .= "</var_def>\n";
	return 1;
}

1;
