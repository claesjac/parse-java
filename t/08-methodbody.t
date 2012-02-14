#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

$ENV{PARSE_JAVA_START_PRODUCTION} = "MethodBody";
require Parse::Java;

# Empty body is ok. 
#my $ast = Parse::Java->parse_string("{}");
#isa_ok($ast, "Parse::Java::MethodBody");

# Blocks
my $ast = Parse::Java->parse_string(q/{
    {}
    foo: {}
}/);
isa_ok($ast, "Parse::Java::MethodBody");
isa_ok($ast->children->[1], "Parse::Java::Block");
isa_ok($ast->children->[2], "Parse::Java::Block");
is($ast->children->[2]->label->to_string, "foo:");

$ast = Parse::Java->parse_string("{ int x; ");
isa_ok($ast, "Parse::Java::MethodBody");
isa_ok($ast->children->[1], "Parse::Java::VariableDecl");
