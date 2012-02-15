#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

use Parser::Java;

my $parser = Parser::Java->new(start => "parse_package");
my $ast = $parser->from_string("package Foo;");
is_deeply($ast, { package => "Foo" });