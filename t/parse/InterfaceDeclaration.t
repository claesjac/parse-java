#!perl

use Test::More tests => 5;

use strict;
use warnings;

BEGIN {
	$ENV{PARSE_JAVA_START_RULE} = "InterfaceDeclaration";
	require Parse::Java;
}

{
	my $ast = Parse::Java->detokenize(Parse::Java->parse_string(<<'END_OF_CODE'));
public interface TestInterface {
}
END_OF_CODE
	
	isa_ok(		$ast, 							'Parse::Java::Document');
	is(			@{$ast->types}, 				1);
	isa_ok(		$ast->types->[0], 				'Parse::Java::Interface');
	is_deeply(	$ast->types->[0]->modifiers, 	['public']);
	is(			$ast->types->[0]->name, 		'TestInterface');
}
