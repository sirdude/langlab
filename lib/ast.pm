package ast;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(new add_node);

my $ast;

sub new {
	$ast = {};
	$ast->{'size'} = 0;
	$ast->{'head'} = 0;
	$ast->{'current'} = 0;
	$ast->{'tmp'} = 0;
	$ast->{'data'} = ();

	return $ast;
}

sub peek {
	return $ast->{'data'}[$ast->{'current'}];
}

sub match {
	my ($str) = @_;
}

sub add_node {
	my ($data) = @_;

	$ast->{'size'} += 1;
	push(@{$ast->{'data'}}, $data);

	return 1;
}

1;
