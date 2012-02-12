#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

$ENV{PARSE_JAVA_START_PRODUCTION} = "Type";
require Parse::Java;

# Basic types
for my $type (qw(byte short char int long float double boolean)) {
    my $ast = Parse::Java->parse_string($type);
    isa_ok($ast, "Parse::Java::PrimitiveType::" . ucfirst($type));
}

# Reference types
my $ast = Parse::Java->parse_string("Foo");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "Foo");

$ast = Parse::Java->parse_string("Foo.Bar");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "Foo.Bar");

$ast = Parse::Java->parse_string("List<String>");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "List<String>");

$ast = Parse::Java->parse_string("Map<String, Object>");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "Map<String,Object>");

$ast = Parse::Java->parse_string("Map<Object, List<? extends Foo>>");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "Map<Object,List<? extends Foo>>");

$ast = Parse::Java->parse_string("Object[][]");
isa_ok($ast, "Parse::Java::ReferenceType");
is($ast->to_string, "Object[][]");
