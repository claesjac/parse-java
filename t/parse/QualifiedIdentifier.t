#!perl

use Test::More tests => 10;

use strict;
use warnings;

BEGIN {
	$ENV{PARSE_JAVA_START_RULE} = "QualifiedIdentifier";
	require Parse::Java;
}

my $ast = Parse::Java->parse_string("Foo");
isa_ok(	$ast, 				'Parse::Java::Identifier');
is( 	$ast->identifier,	'Foo');

$ast = Parse::Java->parse_string("Foo.Bar");
isa_ok( 	$ast,				'Parse::Java::Identifier');
is_deeply(	$ast->children,		['Foo', '.', 'Bar']);
is(			$ast->identifier,	'Foo.Bar');

$ast = Parse::Java->parse_string("Foo.Bar.Baz");
isa_ok( 	$ast,				'Parse::Java::Identifier');
is_deeply(	$ast->children,		['Foo', '.', 'Bar', '.', 'Baz']);
is(			$ast->identifier,	'Foo.Bar.Baz');

$ast = Parse::Java->parse_string("Foo");
isa_ok(	$ast, 					'Parse::Java::Identifier');
isa_ok( $ast->children->[0],	'Parse::Java::Token::Identifier');
