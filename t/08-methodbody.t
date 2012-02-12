#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

$ENV{PARSE_JAVA_START_PRODUCTION} = "MethodBody";
require Parse::Java;

# Empty body is ok. 
my $ast = Parse::Java->parse_string("{}");
isa_ok($ast, "Parse::Java::MethodBody");

# Declaration
$ast = Parse::Java->parse_string("{ {} }");
diag Dumper $ast;
isa_ok($ast, "Parse::Java::MethodBody");
isa_ok($ast->children->[1], "Parse::Java::Block");
