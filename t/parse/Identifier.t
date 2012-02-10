#!perl

use Test::More tests => 4;

use strict;
use warnings;

BEGIN {
	$ENV{PARSE_JAVA_START_RULE} = "Identifier";
	require Parse::Java;
}

my $ast = Parse::Java->parse_string("Foo");
isa_ok(		$ast, 					'Parse::Java::Identifier');
is_deeply(	$ast->children,		 	['Foo']);
isa_ok(		$ast->children->[0], 	'Parse::Java::Token::Identifier');
is( 		$ast->identifier,		'Foo');
