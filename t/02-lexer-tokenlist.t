#!perl

use Test::More;

use strict;
use warnings;

use File::Spec;
use Parse::Java;

open(my $tokenlist, "<:utf8", File::Spec->catfile('t', 'tokenlist.data')) || die $!;
my @tests = grep { /TK$/ } <$tokenlist>;
close($tokenlist);

{
	my $parser = Parse::Java->new();
	$parser->_set_input(join "", @tests);

	sub next_token {
		return $parser->_next_token();
	}
}

# Set number of tests
plan tests => @tests * 2;
for my $test (@tests) {
	chomp $test;
	my ($expect, $type) = split/\s+/, $test, 2;
	
	$expect =~ s/[fFdD]$// 	  if $type eq 'FP_TK';
	$expect =~ s/[lL]$//   	  if $type eq 'INTEGRAL_TK';
	$expect =~ s/^'(.*)'$/$1/ if $type eq 'CHAR_TK';
	$expect =~ s/^"(.*)"$/$1/ if $type eq 'STRING_TK';
	
	my ($token, $value) = next_token;
	
	is($value, $expect, "$type value ok");
	is($token, $type, "$type token ok");

	next_token;
}

1;