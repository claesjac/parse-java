#!perl

use Test::More tests => 7;

use strict;
use warnings;

BEGIN {
	$ENV{PARSE_JAVA_START_RULE} = "ReferenceType";
	require Parse::Java;
}

my $ast = Parse::Java->detokenize(Parse::Java->parse_string("Foo"));
isa_ok(	$ast, 				'Parse::Java::ReferenceType');
is( 	$ast->identifier,	'Foo');

$ast = Parse::Java->detokenize(Parse::Java->parse_string("Foo.Bar"));
isa_ok(	$ast,				'Parse::Java::ReferenceType');
is(		$ast->identifier,	'Foo.Bar');

SKIP: {
	skip "TypeArgument is not yet implemented", 3;
	
	$ast = Parse::Java->detokenize(Parse::Java->parse_string("Foo<Bar>"));
	isa_ok( $ast,					'Parse::Java::ReferenceType');
	is(		$ast->identifier, 		'Foo<Bar>');
	isa_ok(	$ast->children->[1],	'Parse::Java::TypeArgument')
}