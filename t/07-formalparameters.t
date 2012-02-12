#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

$ENV{PARSE_JAVA_START_RULE} = "FormalParameters";
require Parse::Java;

my $ast = Parse::Java->parse_string("()");
isa_ok($ast, "Parse::Java::Parameters");
is($ast->count, 0, "No arguments");

$ast = Parse::Java->parse_string("(int a)");
isa_ok($ast, "Parse::Java::Parameters");
is($ast->count, 1, "One argument");

$ast = Parse::Java->parse_string("(int a, bar[] b)");
isa_ok($ast, "Parse::Java::Parameters");
is($ast->count, 2, "Two arguments");
is($ast->parameter(1)->type->to_string, "bar[]");
is($ast->parameter(1)->type->dimensions, 1);
is($ast->parameter(1)->identifier->to_string, "b");
ok(!$ast->parameter(0)->type->vargs);

$ast = Parse::Java->parse_string("(Object... a)");
isa_ok($ast, "Parse::Java::Parameters");
is($ast->count, 1, "One arguments");
is($ast->parameter(0)->type->dimensions, 1);
is($ast->parameter(0)->type->to_string, "Object...");
ok($ast->parameter(0)->type->vargs);
