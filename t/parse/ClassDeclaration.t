#!perl

use Test::More tests => 9;

use Data::Dumper qw(Dumper);

use strict;
use warnings;

BEGIN {
	$ENV{PARSE_JAVA_START_RULE} = "ClassDeclaration";
	require Parse::Java;
}

{
	my $ast = Parse::Java->parse_string(<<'END_OF_CODE');
class test {
}
END_OF_CODE

	isa_ok(		$ast, 				'Parse::Java::Class');
	is(			$ast->name,			'test');
	is_deeply(	$ast->modifiers, 	[]);
}

{
	my $ast = Parse::Java->parse_string(<<'END_OF_CODE');
public class test {
}
END_OF_CODE
	is(			$ast->name, 		'test');
	is_deeply(	$ast->modifiers, 	['public']);
}

{
	my $ast = Parse::Java->parse_string(<<'END_OF_CODE');
class foo extends bar {
}
END_OF_CODE
	is(			$ast->name, 					'foo');
	isa_ok(		$ast->extends,					'Parse::Java::ReferenceType');
	is(			$ast->extends->identifier,		'bar');
	is_deeply(	$ast->modifiers, 				[]);
}


