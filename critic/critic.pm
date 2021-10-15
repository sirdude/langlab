package critic;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(set_version get_version set_name get_name set_description get_description
	set_explination get_explination set_severity get_severity set_categories get_categories load_policies);

my %moduleinfo;
my %categories;

sub set_version {
	my ($version) = @_;

	if (!$version || $version eq "") {
		$version = "1.0";
	}

	$moduleinfo{'version'} = $version;
}

sub get_version {
	return $moduleinfo{'version'};
}

sub set_description {
	my ($desc) = @_;

	$moduleinfo{'description'} = $desc;
}

sub set_name {
	my ($desc) = @_;

	$moduleinfo{'name'} = $desc;
}

sub get_name {
	return $moduleinfo{'name'};
}

sub get_description {
	return $moduleinfo{'description'};
}

sub set_explination {
	my ($desc) = @_;

	$moduleinfo{'explination'} = $desc;
}

sub get_explination {
	return $moduleinfo{'explination'};
}

# Low,medium,high,parinoid,insane or 1,2,3,4,5
sub set_severity {
	my ($value) = @_;
	$value = lc($value);
	if (($value eq "low") || ($value eq "1")) {
		$moduleinfo{'severity'} = 1;
	} elsif (($value eq "medium") || ($value eq "2") || $value eq "med") {
		$moduleinfo{'severity'} = 2;
	} elsif (($value eq "high") || ($value eq "3")) {
		$moduleinfo{'severity'} = 3;
	} elsif (($value eq "parinoid") || ($value eq "4")) {
		$moduleinfo{'severity'} = 4;
	} elsif (($value eq "insane") || ($value eq "5")) {
		$moduleinfo{'severity'} = 5;
	} else {
		error("Invalid severity: $value\n";
	}
}

sub get_severity {
	return $moduleinfo{'severity'};
}


sub set_categorys {
	my @values = @_;

	foreach my $i (@values) {
		$categories{$i} = 1;
	}
}

sub get_categories {
	my @values = keys(%categories);

	return @values;
}

sub load_policies {
}

set_supported_parameters();

# Functions, documentation, variables, comments etc...
set_applies_to();

1;
